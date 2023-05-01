import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../modules/screens/story_page.dart';
import '../components/components.dart';
import '../styles/colors.dart';

Widget story1() => Scaffold(
      backgroundColor: Colors.yellow,
    );
Widget story2() => Scaffold(
      backgroundColor: Colors.blue,
    );
Widget story3() => Scaffold(
      backgroundColor: Colors.green,
    );

Widget storyCircle({
  context,
}) =>
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              navigateTo(
                context,
                StoryPage(),
              );
            },
            child: Container(
              height: 60,
              width: 60,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: defaultColor),
            ),
          ),
        ],
      ),
    );

Widget progressBar({double percentWatched = 0}) => LinearPercentIndicator(
      progressColor: Colors.grey[400],
      backgroundColor: Colors.grey[600],
      lineHeight: 8,
      percent: percentWatched,
      barRadius: Radius.circular(15),
    );

Widget storyBars({List<double>? percentWatched}) {
  return Padding(
    padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
    child: Container(
      child: Row(children: [
        Expanded(child: progressBar(percentWatched: percentWatched![0])),
        Expanded(child: progressBar(percentWatched: percentWatched[1])),
        Expanded(child: progressBar(percentWatched: percentWatched[2])),
      ]),
    ),
  );
}
