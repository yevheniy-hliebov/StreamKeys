import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';

class SInputDecorationTheme {
  const SInputDecorationTheme._();

  static InputDecorationTheme get light {
    return InputDecorationTheme(
      filled: true,
      hoverColor: SColors.surfaceLight,
      fillColor: SColors.surfaceLight,
      enabledBorder: getBorder(SColors.outlineLight),
      border: getBorder(SColors.outlineLight),
      focusedBorder: getBorder(SColors.primary),
      labelStyle: const TextStyle().copyWith(
        color: SColors.onSurfaceLight,
      ),
      hintStyle: const TextStyle().copyWith(
        color: SColors.onSurfaceLight,
      ),
    );
  }

  static InputDecorationTheme get dark {
    return InputDecorationTheme(
      filled: true,
      hoverColor: SColors.surfaceDark,
      fillColor: SColors.surfaceDark,
      activeIndicatorBorder: getBorder(SColors.outlineDark).borderSide,
      enabledBorder: getBorder(SColors.outlineDark),
      border: getBorder(SColors.outlineDark),
      focusedBorder: getBorder(SColors.primary),
      labelStyle: const TextStyle().copyWith(
        color: SColors.onSurfaceDark,
      ),
      hintStyle: const TextStyle().copyWith(
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
