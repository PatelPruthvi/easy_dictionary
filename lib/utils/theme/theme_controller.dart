import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs)
      : _isDark = _prefs.getBool(_key) ?? false;

  static const String _key = 'isDarkMode';

  final SharedPreferences _prefs;
  bool _isDark;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggle() {
    _isDark = !_isDark;
    _prefs.setBool(_key, _isDark);
    notifyListeners();
  }
}
