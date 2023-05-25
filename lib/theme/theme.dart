import 'package:flutter/material.dart';

ThemeData defaultLightTheme = ThemeData.light(
  useMaterial3: true,
);

ThemeData defaultDarkTheme = ThemeData.dark(
  useMaterial3: true,
);

CardTheme cardTheme =
    const CardTheme(elevation: 10, shadowColor: Colors.transparent);

AppBarTheme appBarTheme =
    const AppBarTheme(backgroundColor: Color.fromARGB(80, 120, 194, 255));

NavigationBarThemeData navigationBarThemeData = const NavigationBarThemeData(
  // backgroundColor: Color.fromARGB(80, 120, 194, 255),
  indicatorColor: Color.fromARGB(80, 120, 194, 255),
);

ThemeData myDarkTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  // colorSchemeSeed: const Color.fromARGB(255, 31, 141, 214),
  brightness: Brightness.dark,
  cardTheme: cardTheme,
  appBarTheme: appBarTheme,
  navigationBarTheme: navigationBarThemeData,
  // fontFamily: 'NotoSerifBengali',
);

ThemeData myLightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  cardTheme: cardTheme,
  appBarTheme: appBarTheme,
  navigationBarTheme: navigationBarThemeData,
  // fontFamily: 'NotoSerifBengali',
);
