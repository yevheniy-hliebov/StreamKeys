import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/common/theme/custom/app_bar_theme.dart';
import 'package:streamkeys/common/theme/custom/icon_button_theme.dart';
import 'package:streamkeys/common/theme/custom/input_decoration_theme.dart';
import 'package:streamkeys/common/theme/custom/outlined_button_theme.dart';
import 'package:streamkeys/common/theme/custom/progress_indicator_theme.dart';
import 'package:streamkeys/common/theme/custom/text_theme.dart';

class STheme {
  const STheme._();

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: SColors.bg,
      appBarTheme: SAppBarTheme.light,
      textTheme: STextTheme.light,
      outlinedButtonTheme: SOutlinedButtonTheme.light,
      iconButtonTheme: SIconButtonTheme.light,
      inputDecorationTheme: SInputDecorationTheme.light,
      progressIndicatorTheme: SProgressIndicatorTheme.light,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SColors.bgInverse,
      appBarTheme: SAppBarTheme.dark,
      textTheme: STextTheme.dark,
      outlinedButtonTheme: SOutlinedButtonTheme.dark,
      iconButtonTheme: SIconButtonTheme.dark,
      inputDecorationTheme: SInputDecorationTheme.dark,
      progressIndicatorTheme: SProgressIndicatorTheme.dark,
    );
  }

  static bool isLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }
}
