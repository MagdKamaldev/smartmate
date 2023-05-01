import 'package:flutter/material.dart';
import 'package:smartmate/shared/styles/colors.dart';
import '../../shared/story_components/story_components.dart';

class StoriesScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Icon(
                    Icons.add,
                    color: defaultColor,
                    size: 35,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Add a Story",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: defaultColor),
              )
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              itemBuilder: (context, index) => storyCircle(context: context),
              itemCount: 10,
              scrollDirection: Axis.vertical,
            ),
          ),
        )
      ],
    );
  }
}
