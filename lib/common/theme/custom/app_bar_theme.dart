import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class SAppBarTheme {
  const SAppBarTheme._();

  static AppBarTheme get light {
    return const AppBarTheme(
      backgroundColor: SColors.bg,
      surfaceTintColor: SColors.bg,
      titleTextStyle: TextStyle(
        fontSize: 20,
        color: SColors.text,
      ),
      titleSpacing: 0,
    );
  }

  static AppBarTheme get dark {
    return const AppBarTheme(
      backgroundColor: SColors.bgInverse,
      surfaceTintColor: SColors.bgInverse,
      titleTextStyle: TextStyle(
        fontSize: 20,
        color: SColors.textInverse,
      ),
      titleSpacing: 0,
    );
  }
}
