import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';

class SOutlinedButtonTheme {
  const SOutlinedButtonTheme._();

  static OutlinedButtonThemeData get light {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: borderRadius,
        side: _borderSide(SColors.outlineLight),
        overlayColor: SColors.overlayLight,
        textStyle: const TextStyle(
          color: SColors.onBackgroundLight,
          fontSize: 16,
        ),
        foregroundColor: SColors.onBackgroundLight,
      ),
    );
  }

  static OutlinedButtonThemeData get dark {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: borderRadius,
        side: _borderSide(SColors.outlineDark),
        overlayColor: SColors.overlayDark,
        textStyle: const TextStyle(
          color: SColors.onBackgroundDark,
          fontSize: 16,
        ),
        foregroundColor: SColors.onBackgroundDark,
      ),
    );
  }

  static RoundedRectangleBorder get borderRadius {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    );
  }

  static BorderSide _borderSide(Color color) {
    return BorderSide(
      color: color,
      width: 1,
    );
  }
}