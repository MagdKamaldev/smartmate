// ignore_for_file: must_be_immutable, override_on_non_overriding_member
import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/story_model.dart';
import '../../shared/story_components/story_components.dart';

class StoryPage extends StatefulWidget {
  @override
  final StoryModel model;
  StoryPage({required this.model});
  State<StoryPage> createState() => _StoryPageState(model: model);
}

class _StoryPageState extends State<StoryPage> {
  final StoryModel model;
  _StoryPageState ({required this.model});


  int currentStoryIndex = 0;

  List<double> percentWatched = [];

  @override
  void initState() {
    super.initState();
    percentWatched = [0]; // Initialize with 0 for the only story
    _startWatching();
  }

  void _startWatching() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        if (percentWatched[currentStoryIndex] + 0.01 < 1) {
          percentWatched[currentStoryIndex] += 0.01;
        } else {
          percentWatched[currentStoryIndex] = 1;
          timer.cancel();
          Navigator.pop(context);
        }
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 2) {
      setState(() {
        if (currentStoryIndex > 0) {
          percentWatched[currentStoryIndex - 1] = 0;
          percentWatched[currentStoryIndex] = 0;
          currentStoryIndex--;
        }
      });
    } else {
      setState(() {
        percentWatched[currentStoryIndex] = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details),
      child: Scaffold(
        body: Stack(
          children: [
            story1(model,context),
            storyBars(percentWatched: percentWatched),
          ],
        ),
      ),
    );
  }
}
