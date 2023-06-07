import 'package:flutter/material.dart';
import 'package:preptime/data/classes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  Locale _locale = const Locale('bn');
  ThemeMode _themeMode = ThemeMode.light;
  Classes? _selectedClass;

  SettingsProvider() {
    retrieveSettings();
  }

  Locale getLocale() {
    return _locale;
  }

  ThemeMode getThemeMode() {
    return _themeMode;
  }

  Classes? getSelectedClass() {
    return _selectedClass;
  }

  setSelectedClass(Classes selectedClass) async {
    _selectedClass = selectedClass;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedClass', selectedClass.toString());

    notifyListeners();
  }

  retrieveSelectedClass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedClass = Classes.fromString(prefs.getString('selectedClass') ?? '');
  }

  retrieveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode =
        prefs.getBool('dark') ?? false ? ThemeMode.dark : ThemeMode.light;
    _locale = Locale(prefs.getString('locale') ?? 'bn');
    await retrieveSelectedClass();
    notifyListeners();
  }

  swithThemeMode() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    saveSettings();
    notifyListeners();
  }

  switchLocale() {
    if (_locale == const Locale('bn')) {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('bn');
    }
    saveSettings();
    notifyListeners();
  }

  saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', _locale.toLanguageTag());
    prefs.setBool('dark', _themeMode == ThemeMode.dark);
  }
}
