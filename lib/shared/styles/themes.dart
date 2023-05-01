// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      iconTheme: IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: "Roboto"),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      elevation: 30.0,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.3,
      ),
    ),
    fontFamily: "Roboto",
    primarySwatch: defaultColor);

ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: HexColor("333739"),
    appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      iconTheme: IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor("333739"),
        statusBarBrightness: Brightness.light,
      ),
      backgroundColor: HexColor("333739"),
      elevation: 0.0,
      titleTextStyle: TextStyle(
          fontFamily: "Cairo",
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: HexColor("333739"),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      elevation: 30.0,
      unselectedItemColor: Colors.grey,
      backgroundColor: HexColor("333739"),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 18,
        fontFamily: "Cairo",
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.3,
      ),
    ),
    fontFamily: "Cairo",
    primarySwatch: defaultColor);
