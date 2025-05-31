import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';

class SOutlinedButtonTheme {
  const SOutlinedButtonTheme._();

  static OutlinedButtonThemeData get light {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
        shape: WidgetStateProperty.all(borderRadius),
        side: WidgetStateProperty.all(_borderSide(SColors.outlineLight)),
        foregroundColor: WidgetStateProperty.all(SColors.onBackgroundLight),
        textStyle: WidgetStateProperty.all(const TextStyle(
          color: SColors.onBackgroundLight,
          fontSize: 18,
        )),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return SColors.overlayLight;
          }
          return Colors.transparent;
        }),
      ),
    );
  }

  static OutlinedButtonThemeData get dark {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
        shape: WidgetStateProperty.all(borderRadius),
        side: WidgetStateProperty.all(_borderSide(SColors.outlineDark)),
        foregroundColor: WidgetStateProperty.all(SColors.onBackgroundDark),
        textStyle: WidgetStateProperty.all(const TextStyle(
          color: SColors.onBackgroundDark,
          fontSize: 18,
        )),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return SColors.overlayDark;
          }
          return Colors.transparent;
        }),
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
