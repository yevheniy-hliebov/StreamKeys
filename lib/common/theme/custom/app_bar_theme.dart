import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class SAppBarTheme {
  const SAppBarTheme._();

  static AppBarTheme get light {
    return const AppBarTheme(
      backgroundColor: SColors.backgroundLight,
      surfaceTintColor: SColors.backgroundLight,
      titleTextStyle: TextStyle(
        fontSize: 20,
        color: SColors.onBackgroundLight,
      ),
      titleSpacing: 0,
    );
  }

  static AppBarTheme get dark {
    return const AppBarTheme(
      backgroundColor: SColors.backgroundDark,
      surfaceTintColor: SColors.backgroundDark,
      titleTextStyle: TextStyle(
        fontSize: 20,
        color: SColors.onBackgroundDark,
      ),
      titleSpacing: 0,
    );
  }
}
