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

BorderSide chipBorderOnColor = const BorderSide(color: Colors.transparent);

FilledButtonThemeData _filledButtonThemeData = FilledButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
);

ElevatedButtonThemeData _elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    elevation: const MaterialStatePropertyAll(0),
  ),
);

ButtonThemeData _buttonThemeData = ButtonThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(1),
  ),
);

ThemeData myDarkTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  // colorSchemeSeed: const Color.fromARGB(255, 31, 141, 214),
  brightness: Brightness.dark,
  cardTheme: cardTheme,
  filledButtonTheme: _filledButtonThemeData,
  elevatedButtonTheme: _elevatedButtonThemeData,
  buttonTheme: _buttonThemeData,
  navigationBarTheme: navigationBarThemeData,
  navigationRailTheme: navigationRailThemeData,
  // fontFamily: 'NotoSerifBengali',
);

ThemeData myLightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  cardTheme: cardTheme,
  buttonTheme: _buttonThemeData,
  filledButtonTheme: _filledButtonThemeData,
  elevatedButtonTheme: _elevatedButtonThemeData,
  navigationBarTheme: navigationBarThemeData,
  navigationRailTheme: navigationRailThemeData,
  // fontFamily: 'NotoSerifBengali',
);
