import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/theme_mode_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeModeService _themeModeService = ThemeModeService();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode value) {
    _themeMode = value;
    _themeModeService.saveThemeMode(value);
    notifyListeners();
  }

  void setModeByBool(bool value) {
    ThemeMode mode = ThemeMode.light;
    switch (value) {
      case false:
        mode = ThemeMode.light;
        break;
      case true:
        mode = ThemeMode.dark;
        break;
    }
    themeMode = mode;
  }

  Future<void> _loadThemeMode() async {
    _themeMode = await _themeModeService.getThemeMode();
    notifyListeners();
  }
}
