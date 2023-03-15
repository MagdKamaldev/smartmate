// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:smartmate/layout/home_layout.dart';
import 'package:smartmate/modules/onBoarding/on_boarding.dart';
import 'package:smartmate/shared/components/constants.dart';
import 'package:smartmate/shared/cubit/login/login_cubit.dart';
import 'package:smartmate/shared/networks/local/cache_helper.dart';
import 'package:smartmate/shared/styles/colors.dart';
import 'modules/login/login_screen.dart';
import 'shared/cubit/app/app_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Widget? widget;
  bool? onBoarding = CacheHelper.getData(key: "onBoarding");
  uid = CacheHelper.getData(key: "uid");

  if (onBoarding != null) {
    if (uid != null) {
      widget = HomeScreen();
    } else {
      widget = LoginScreen();
    }
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: defaultColor, // Set the status bar color to red
      ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => AppCubit()..getUsers()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: Consumer<LoginCubit>(
          builder: (context, internetProvider, child) {
            return startWidget;
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
