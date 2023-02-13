// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/components/components.dart';
import '../../shared/networks/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../login/login_screen.dart';

class BoardingModel {
  final String title;
  Widget? animation;
  final String body;
  BoardingModel({
    required this.title,
    required this.animation,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
        title: "Unlimited access",
        animation: LottieBuilder.network(
            "https://assets6.lottiefiles.com/packages/lf20_eYXADRNJPy.json"),
        body: "Chat with anyone you want , anywhere at anytime "),
    BoardingModel(
        title: "AI model",
        animation: LottieBuilder.network(
            "https://assets1.lottiefiles.com/packages/lf20_itilDAyVNt.json"),
        body: "Enjoy chatting with our amazing chatbot"),
    BoardingModel(
        title: "Community",
        animation: LottieBuilder.network(
            "https://assets6.lottiefiles.com/packages/lf20_gzl797gs.json"),
        body: "Build your own community with your own way"),
  ];

  bool isLast = false;
  
  void submit() {
    CacheHelper.saveData(key: "onBoarding", value: true).then((value) {
      if (value) {
        navigateAndFinish(context, LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildOnBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardController,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: defaultColor,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 4,
                      spacing: 5,
                    ),
                    count: boarding.length),
                Spacer(),
                FloatingActionButton(
                  backgroundColor: defaultColor,
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardController.nextPage(
                          duration: Duration(
                            milliseconds: 750,
                          ),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: Icon(Icons.arrow_forward),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: model.animation!,
          ),
          Center(
            child: Text(model.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              model.body,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      );
}
