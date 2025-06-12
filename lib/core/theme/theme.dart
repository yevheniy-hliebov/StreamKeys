import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light = _getTheme(AppColors.light, Brightness.light);
  static ThemeData dark = _getTheme(AppColors.dark, Brightness.dark);

  static ThemeData _getTheme(AppColorsData colors, Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: colors.primary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        outline: colors.outline,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: colors.background,
    );
  }
}
