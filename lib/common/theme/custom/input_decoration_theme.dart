import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class SInputDecorationTheme {
  const SInputDecorationTheme._();

  static InputDecorationTheme get light {
    return InputDecorationTheme(
      border: getBorder(SColors.border),
      focusedBorder: getBorder(SColors.borderFocused),
      labelStyle: const TextStyle().copyWith(
        color: SColors.text,
      ),
    );
  }

  static InputDecorationTheme get dark {
    return InputDecorationTheme(
      border: getBorder(SColors.border),
      focusedBorder: getBorder(SColors.borderFocused),
      labelStyle: const TextStyle().copyWith(
        color: SColors.textInverse,
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
