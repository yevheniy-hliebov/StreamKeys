import 'package:flutter/material.dart';

class SOutlinedButtonTheme {
  const SOutlinedButtonTheme._();

  static const Color defaultLightColor = Color(0xFF2F2F2F);
  static const Color defaultDarkColor = Color(0xFFECECEC);

  static OutlinedButtonThemeData get light {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        overlayColor: Colors.grey,
        textStyle: const TextStyle().copyWith(
          color: defaultLightColor,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData get dark {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        overlayColor: Colors.grey[900],
        textStyle: const TextStyle().copyWith(
          color: defaultLightColor,
        ),
      ),
    );
  }
}
