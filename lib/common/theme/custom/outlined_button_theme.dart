import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class SOutlinedButtonTheme {
  const SOutlinedButtonTheme._();

  static OutlinedButtonThemeData get light {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: borderRadius,
        side: _borderSide(SColors.border),
        overlayColor: SColors.overlayColor,
        textStyle: const TextStyle(
          color: SColors.text,
          fontSize: 16,
        ),
        foregroundColor: SColors.text,
      ),
    );
  }

  static OutlinedButtonThemeData get dark {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: borderRadius,
        side: _borderSide(SColors.borderInverse),
        overlayColor: SColors.overlayColorInverse,
        textStyle: const TextStyle(
          color: SColors.textInverse,
          fontSize: 16,
        ),
        foregroundColor: SColors.textInverse,
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
