import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class SListTileTheme {
  const SListTileTheme._();

  static ListTileThemeData get light {
    return ListTileThemeData(
      tileColor: SColors.backgroundLight,
      titleTextStyle: const TextStyle().copyWith(
        color: SColors.onBackgroundLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      subtitleTextStyle: const TextStyle().copyWith(
        color: SColors.onBackgroundLight,
        fontWeight: FontWeight.w400,
      ),
      iconColor: SColors.onBackgroundLight,
    );
  }

  static ListTileThemeData get dark {
    return ListTileThemeData(
      tileColor: SColors.backgroundDark,
      titleTextStyle: const TextStyle().copyWith(
        color: SColors.onBackgroundDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      subtitleTextStyle: const TextStyle().copyWith(
        color: SColors.onBackgroundDark,
        fontWeight: FontWeight.w400,
      ),
      iconColor: SColors.onBackgroundDark,
    );
  }
}
