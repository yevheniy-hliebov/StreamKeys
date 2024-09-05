import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/custom/text_theme.dart';

class STheme {
  const STheme._();

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.white,
      textTheme: STextTheme.light,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFF333333),
      textTheme: STextTheme.dark,
    );
  }
}