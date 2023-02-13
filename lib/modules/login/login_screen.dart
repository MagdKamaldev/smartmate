// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:smartmate/layout/home_layout.dart';
import 'package:smartmate/shared/components/components.dart';
import 'package:smartmate/shared/cubit/login/internet_provider.dart';
import 'package:smartmate/shared/cubit/login/login_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();

  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/Heading.png",
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome to smart mate",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "The faster You login the more you enjoy the experience ",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 13.5, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RoundedLoadingButton(
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.red,
                  controller: googleController,
                  successColor: Colors.red,
                  onPressed: () {
                    handleGoogleSignIn();
                  },
                  child: Wrap(
                    children: const [
                      Icon(
                        FontAwesomeIcons.google,
                        size: 20,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Sign in with Google",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedLoadingButton(
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.blue,
                  controller: facebookController,
                  successColor: Colors.blue,
                  onPressed: () {},
                  child: Wrap(
                    children: const [
                      Icon(
                        FontAwesomeIcons.facebook,
                        size: 20,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Sign in with Facebook",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Future handleGoogleSignIn() async {
    final sp = context.read<LoginProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(context, "check your connection !", Colors.red);
      googleController.reset();
      facebookController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), Colors.red);
          googleController.reset();
        } else {
          sp.checkIfUserExists().then((value) async {
            if (value == true) {
              await sp.getUserDataFromFirebase(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            } else {
              sp.saveDataToFireBase().then((value) {
                sp.saveDataToSharedPreferences().then((value) {
                  sp.setSignIn().then((value) {
                    googleController.success();
                    handleAfterSignIn();
                  });
                });
              });
            }
          });
        }
      });
    }
  }

  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      navigateAndFinish(
        context,
        HomeLayout(),
      );
    });
  }
}
