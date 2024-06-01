import 'package:flutter/material.dart';


class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    if (_themeData != themeData) {
      _themeData = themeData;
      notifyListeners();  // Important: Notify listeners about the change
    }
  }
  
  void toggleTheme() {
    themeData = _themeData.brightness == Brightness.light
      ? ThemeData.dark()
      : ThemeData.light();
  }
}
