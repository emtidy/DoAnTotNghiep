import 'package:flutter/material.dart';

import '../colors/color.dart';

class MyAppThemes {
  static final lightTheme = ThemeData(
    textTheme: const TextTheme(
      titleSmall: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: TextStyle(
        color: Colors.black,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    ),
      scaffoldBackgroundColor: Styles.greyLight,
    iconTheme: const IconThemeData(
      color: Styles.dark, // Replace `AppsColor.dark` with your defined color.
    ),
    focusColor: Styles.blue, // Replace `AppsColor.blue` with your defined color.
    primaryColorLight: Styles.blue, // Replace `AppsColor.blue` with your defined color.
    fontFamily: "Merriweather", // Replace "Inter" with the font family you want to use.
    appBarTheme: const AppBarTheme(
      backgroundColor: Styles.light,
      titleTextStyle: TextStyle(
        color: Color(0xFF202020),
        fontSize: 28,
      )
    )
  );
  static final darkTheme = ThemeData(
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        color: Styles.light,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: Styles.light,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: TextStyle(
        color: Styles.light,
        fontSize: 12,
        fontWeight: FontWeight.w400,
          letterSpacing: 4.5
      ),
      headlineLarge: TextStyle(
        color: Styles.light,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 4.5
      ),
    ),
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(
      color:Styles.light, // Replace `AppsColor.dark` with your defined color.
    ),
    focusColor: Styles.blue, // Replace `AppsColor.blue` with your defined color.
    primaryColorLight: Styles.blue, // Replace `AppsColor.blue` with your defined color.
    fontFamily: "Merriweather", // Replace "Inter" with the font family you want to use.
    appBarTheme: const AppBarTheme(
      backgroundColor: Styles.light,
      titleTextStyle: TextStyle(
        color: Styles.light,
        fontSize: 28,
      )
    )
  );
}
