import 'dart:ui';

import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TextTheme(
      headline2: TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontSize: 20,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
      ),
      headline1: TextStyle(
        fontSize: 40,
        color: Colors.white,
        fontFamily: 'Poppins',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      bodyText2: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      button: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0.0,
      actionsIconTheme: IconThemeData(
        size: 30.0,
        color: Colors.white,
      ),
      textTheme: TextTheme(
        headline2: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 20,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
        ),
        headline1: TextStyle(
          fontSize: 40,
          color: Colors.white,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white, backgroundColor: buttonColorDark),
    backgroundColor: gradientStartColorDark);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: TextTheme(
    headline2: TextStyle(
      color: Colors.black87,
      fontFamily: 'Poppins',
      fontSize: 20,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
    ),
    headline1: TextStyle(
      fontSize: 40,
      color: Colors.black54,
      fontFamily: 'Poppins',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontFamily: 'Poppins',
    ),
    bodyText2: TextStyle(
      fontSize: 12,
      color: Colors.black87,
      fontFamily: 'Poppins',
    ),
    button: TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontFamily: 'Poppins',
    ),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0.0,
    actionsIconTheme: IconThemeData(
      size: 30.0,
      color: Colors.black87,
    ),
    textTheme: TextTheme(
      headline2: TextStyle(
        color: Colors.black87,
        fontFamily: 'Poppins',
        fontSize: 20,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
      ),
      headline1: TextStyle(
        fontSize: 40,
        color: Colors.black87,
        fontFamily: 'Poppins',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: buttonColorDark,
    backgroundColor: Colors.white,
  ),
  backgroundColor: gradientStartColor,
);

const gradientStartColor = Color(0xffE1F8FF);
const gradientEndColor = Color(0xffA6E9FF);
const frontTitleBackground = Color(0xffEBEEF1);
const textColor = Colors.black54;
const buttonColor = Color(0xffB2E5F6);
const labelColor = Color(0xff3333333);
const borderColor = Color(0x1500001F);
const hintColor = Color(0xff000000);
const iconColor = Color(0xff004861);
const dropdownArrowColor = Color(0xff606262);

const gradientStartColorDark = Color(0xff004861);
const gradientEndColorDark = Color(0xff013E53);
const frontTitleBackgroundDark = Color(0xff002b3a);
const textColorDark = Colors.white;
const buttonColorDark = Color(0xff0A4357);
const labelColorDark = Color(0xff3333333);
const borderColorDark = Color(0x1500001F);
const hintColorDark = Color(0xff000000);
const iconColorDark = Color(0xff004861);
const dropdownArrowColorDark = Color(0xff606262);
