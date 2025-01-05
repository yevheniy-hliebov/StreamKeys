import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeService {
  static const _themeModeKey = 'theme_mode';

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    switch (themeMode) {
      case ThemeMode.light:
        await prefs.setString(_themeModeKey, 'light');
        break;
      case ThemeMode.dark:
        await prefs.setString(_themeModeKey, 'dark');
        break;
      case ThemeMode.system:
        await prefs.setString(_themeModeKey, 'system');
        break;
    }
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);

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
