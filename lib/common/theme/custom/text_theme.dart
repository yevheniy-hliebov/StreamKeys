import 'package:flutter/material.dart';

class STextTheme {
  const STextTheme._();

  static const Color defaultLightColor = Color(0xFF2F2F2F);
  static const Color defaultDarkColor = Color(0xFFECECEC);

  static TextTheme get light => getTheme(defaultLightColor);
  static TextTheme get dark => getTheme(defaultDarkColor);

  static TextTheme getTheme(Color color) {
    return TextTheme(
      bodyLarge: const TextStyle().copyWith(color: color),
      bodyMedium: const TextStyle().copyWith(color: color),
      bodySmall: const TextStyle().copyWith(color: color),
      displayLarge: const TextStyle().copyWith(color: color),
      displayMedium: const TextStyle().copyWith(color: color),
      displaySmall: const TextStyle().copyWith(color: color),
      headlineLarge: const TextStyle().copyWith(color: color),
      headlineMedium: const TextStyle().copyWith(color: color),
      headlineSmall: const TextStyle().copyWith(color: color),
      labelLarge: const TextStyle().copyWith(color: color),
      labelMedium: const TextStyle().copyWith(color: color),
      labelSmall: const TextStyle().copyWith(color: color),
      titleLarge: const TextStyle().copyWith(color: color),
      titleMedium: const TextStyle().copyWith(color: color),
      titleSmall: const TextStyle().copyWith(color: color),
    );
  }
}