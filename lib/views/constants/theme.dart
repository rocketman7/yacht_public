import 'package:flutter/material.dart';

import 'view_constants.dart';

ThemeData theme() {
  return ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kPrimaryBackGroundColorLight,
        elevation: 0.0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: kTextColor)),
    scaffoldBackgroundColor: kPrimaryBackGroundColorLight,
    fontFamily: "AppleSD",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    headline3: TextStyle(
        fontFamily: "AppleSD",
        color: kTextColor,
        fontSize: 26,
        fontWeight: FontWeight.w700),
    headline5: TextStyle(
        fontFamily: "AppleSD",
        color: kTextColor,
        fontSize: 24,
        fontWeight: FontWeight.w700),
    headline6: TextStyle(
        fontFamily: "AppleSD",
        color: kTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w700),
    bodyText1: TextStyle(fontFamily: "AppleSD", color: kTextColor),
    bodyText2: TextStyle(fontFamily: "AppleSD", color: kTextColor),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: Colors.white,
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    ),
  );
}
