import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class SInputDecorationTheme {
  const SInputDecorationTheme._();

  static InputDecorationTheme get light {
    return InputDecorationTheme(
      border: getBorder(SColors.outlineLight),
      focusedBorder: getBorder(SColors.primary),
      labelStyle: const TextStyle().copyWith(
        color: SColors.onSurfaceLight,
      ),
    );
  }

  static InputDecorationTheme get dark {
    return InputDecorationTheme(
      border: getBorder(SColors.onBackgroundDark),
      focusedBorder: getBorder(SColors.primary),
      labelStyle: const TextStyle().copyWith(
        color: SColors.onSurfaceDark,
      ),
    );
  }

  static InputBorder getBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(5),
    );
  }
}
