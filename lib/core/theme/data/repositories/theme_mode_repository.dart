import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeRepository {
  static const String themeModeKey = 'theme_mode';

  final SharedPreferences prefs;

  ThemeModeRepository(this.prefs);

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await prefs.setString(themeModeKey, themeMode.name);
  }

  Future<ThemeMode> getThemeMode() async {
    final String? themeModeString = prefs.getString(themeModeKey);

    if (themeModeString == ThemeMode.light.name) {
      return ThemeMode.light;
    } else if (themeModeString == ThemeMode.dark.name) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }
}
