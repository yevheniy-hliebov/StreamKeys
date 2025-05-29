import 'package:flutter/material.dart';

class SFilledButtonTheme {
  const SFilledButtonTheme._();

  static FilledButtonThemeData get light {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
        ),
        shape: borderRadius,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }

  static FilledButtonThemeData get dark {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
        ),
        shape: borderRadius,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }

  static RoundedRectangleBorder get borderRadius {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    );
  }
}
