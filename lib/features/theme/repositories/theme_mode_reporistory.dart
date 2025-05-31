import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/common/models/typedefs.dart';

class ThemeModeRepository {
  static const themeModeKey = 'theme_mode';

  final SharedPreferences? sharedPreferences;

  ThemeModeRepository({this.sharedPreferences});

  FutureVoid saveThemeMode(ThemeMode themeMode) async {
    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();
    switch (themeMode) {
      case ThemeMode.light:
        await prefs.setString(themeModeKey, 'light');
        break;
      case ThemeMode.dark:
        await prefs.setString(themeModeKey, 'dark');
        break;
      case ThemeMode.system:
        await prefs.setString(themeModeKey, 'system');
        break;
    }
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(themeModeKey);

    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
