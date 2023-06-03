import 'package:flutter/material.dart';
import 'package:preptime/data/classes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  Locale locale = const Locale('bn');
  ThemeMode themeMode = ThemeMode.light;
  Classes? selectedClass;

  SettingsProvider() {
    getSettings();
  }

  setSelectedClass(Classes selectedClass) async {
    this.selectedClass = selectedClass;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedClass', selectedClass.toString());

    notifyListeners();
  }

  getSelectedClass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedClass = Classes.fromString(prefs.getString('selectedClass') ?? '');
  }

  getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeMode =
        prefs.getBool('dark') ?? false ? ThemeMode.dark : ThemeMode.light;
    locale = Locale(prefs.getString('locale') ?? 'bn');
    await getSelectedClass();
    notifyListeners();
  }

  swithThemeMode() {
    if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    saveSettings();
    notifyListeners();
  }

  switchLocale() {
    if (locale == const Locale('bn')) {
      locale = const Locale('en');
    } else {
      locale = const Locale('bn');
    }
    saveSettings();
    notifyListeners();
  }

  saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', locale.toLanguageTag());
    prefs.setBool('dark', themeMode == ThemeMode.dark);
  }
}
