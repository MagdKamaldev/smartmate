// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'dart:math' as math;


class LoadingAnimation extends StatefulWidget {
  @override
  State<LoadingAnimation> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? animcontroller;

  @override
  void initState() {
    super.initState();
    animcontroller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
        parent: animcontroller!,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);

    animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).chain(CurveTween(curve: Curves.bounceIn)).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animcontroller!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animcontroller!.forward();
        }
      });

    animcontroller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: animation!.value,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Image.asset("assets/images/icons8-hourglass-96.png"),
      ),
    );
  }

  @override
  void dispose() {
    animcontroller!.dispose();
    super.dispose();
  }
}
