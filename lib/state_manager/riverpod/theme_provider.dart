import 'package:flutter/material.dart';
import 'package:rally/main.dart';

class ThemeProvider extends ChangeNotifier{
  late ThemeMode _currentMode;

  get currentMode => _currentMode;

  ThemeProvider(){
    int? value = prefs.getInt('THEME_MODE');
    _currentMode = intToMode(value);
  }

  ThemeMode intToMode(int? value){
    const map = {
      0: ThemeMode.light,
      1: ThemeMode.dark,
      2: ThemeMode.system
    };

    return map[value]?? ThemeMode.system;
  }

  int modeToInt(ThemeMode mode){
    const map = {
      ThemeMode.light: 0,
      ThemeMode.dark: 1,
      ThemeMode.system: 2,
    };

    return map[mode]?? 2;
  }

  switchThemeMode(int value){
    _currentMode = intToMode(value);
    prefs.setInt('THEME_MODE', value);
    notifyListeners();
  }
}