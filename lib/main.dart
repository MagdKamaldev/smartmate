// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartmate/modules/no_connection/no_connection_screen.dart';
import 'package:smartmate/modules/onBoarding/on_boarding.dart';
import 'package:smartmate/shared/cubit/login/login_provider.dart';
import 'package:smartmate/shared/networks/local/cache_helper.dart';
import 'modules/login/login_screen.dart';
import 'shared/cubit/login/internet_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Widget? widget;
  bool? onBoarding = CacheHelper.getData(key: "onBoarding");

  if (onBoarding != null) {
    widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  MyApp({required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => InternetProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: Consumer<InternetProvider>(
          builder: (context, internetProvider, child) {
            return internetProvider.hasInternet
                ? startWidget
                : NoConnectionScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
