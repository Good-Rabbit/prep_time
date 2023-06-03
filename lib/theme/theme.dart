import 'package:flutter/material.dart';

ThemeData defaultLightTheme = ThemeData.light(
  useMaterial3: true,
);

ThemeData defaultDarkTheme = ThemeData.dark(
  useMaterial3: true,
);

Color themeColorWithAlpha = const Color.fromARGB(115, 85, 179, 255);

CardTheme cardTheme =
    const CardTheme(elevation: 10, shadowColor: Colors.transparent);

NavigationBarThemeData navigationBarThemeData = NavigationBarThemeData(
  // backgroundColor: Color.fromARGB(80, 120, 194, 255),
  indicatorColor: themeColorWithAlpha,
);

NavigationRailThemeData navigationRailThemeData = NavigationRailThemeData(
  indicatorColor: themeColorWithAlpha,
);

ThemeData myDarkTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  // colorSchemeSeed: const Color.fromARGB(255, 31, 141, 214),
  brightness: Brightness.dark,
  cardTheme: cardTheme,
  navigationBarTheme: navigationBarThemeData,
  navigationRailTheme: navigationRailThemeData,
  // fontFamily: 'NotoSerifBengali',
);

ThemeData myLightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  cardTheme: cardTheme,
  navigationBarTheme: navigationBarThemeData,
  navigationRailTheme: navigationRailThemeData,
  // fontFamily: 'NotoSerifBengali',
);
