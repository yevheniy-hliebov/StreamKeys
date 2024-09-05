import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/custom/app_bar_theme.dart';
import 'package:streamkeys/common/theme/custom/outlined_button_theme.dart';
import 'package:streamkeys/common/theme/custom/text_theme.dart';

class STheme {
  const STheme._();

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: SAppBarTheme.light,
      textTheme: STextTheme.light,
      outlinedButtonTheme: SOutlinedButtonTheme.light
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF333333),
      appBarTheme: SAppBarTheme.dark,
      textTheme: STextTheme.dark,
      outlinedButtonTheme: SOutlinedButtonTheme.dark,
    );
  }

  static bool isLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }
}
