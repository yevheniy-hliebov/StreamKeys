import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class STextTheme {
  const STextTheme._();

  static TextTheme get light => getTheme(SColors.text);
  static TextTheme get dark => getTheme(SColors.textInverse);

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
