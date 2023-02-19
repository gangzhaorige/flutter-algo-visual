import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  bool _isLight = true;

  isLight() => _isLight;

  void toggle() async {
    if(_isLight) {
      _isLight = false;
      setTheme(darkTheme);
    } else {
      _isLight = true;
      setTheme(lightTheme);
    }
    notifyListeners();
  }

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}


final lightTheme = ThemeData(
  primaryColor: Colors.blue,
  primaryColorLight: Colors.blue,
  iconTheme: const IconThemeData(
    color: Colors.blue,
  ),
  // dividerColor: Colors.black,
  // brightness: Brightness.dark,
  // primarySwatch: Colors.teal,
  // canvasColor: const Color.fromARGB(255,41,45,62),
);

final darkTheme = ThemeData(
  primaryColor: const Color.fromARGB(255, 28,30,43),
  primaryColorLight: Colors.black,
  scaffoldBackgroundColor: const Color.fromARGB(255,41,45,62),
  dividerColor: Colors.black,
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  canvasColor: const Color.fromARGB(255,41,45,62),
);

