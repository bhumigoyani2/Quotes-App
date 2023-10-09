import 'package:flutter/material.dart';

class LightTheme {
  final ThemeData data = ThemeData.light();
}

class DarkTheme {
  final ThemeData data = ThemeData.dark();
}


class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = DateTime.now().hour >= 18 || DateTime.now().hour < 6
      ? DarkTheme().data
      : LightTheme().data;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme = _currentTheme == LightTheme().data
        ? DarkTheme().data
        : LightTheme().data;
    notifyListeners();
  }
}
