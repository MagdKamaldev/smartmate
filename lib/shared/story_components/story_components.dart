import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../models/story_model.dart';
import '../../modules/screens/story_page.dart';
import '../components/components.dart';

Widget story1(StoryModel model, context) => Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              model.image!,
                            ),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    model.name.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    model.dateTime!.substring(11, 16).toString(),
                    style: TextStyle(color: Colors.grey[500]),
                  )
                ],
              ),
              Spacer(),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: 550,
                  child: Image.network(
                    model.storyImage.toString(),
                    fit: BoxFit.cover,
                  )),
              SizedBox(
                height: 30,
              ),
              Text(
                model.text!,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );

Widget storyCircle({
  StoryModel? model,
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
                StoryPage(
                  model: model,
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                            model!.image!,
                          ),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(model.name.toString()),
                SizedBox(
                  width: 20,
                ),
                Text(
                  model.dateTime!.substring(11, 16).toString(),
                  style: TextStyle(color: Colors.grey),
                )
              ],
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
      ]),
    ),
  );
}
