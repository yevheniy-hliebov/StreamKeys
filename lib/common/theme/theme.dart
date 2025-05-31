import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/theme/custom/filled_button_theme.dart';
import 'package:streamkeys/common/theme/custom/index.dart';

class STheme {
  const STheme._();

  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: SColors.primary,
        surface: SColors.surfaceLight,
        onSurface: SColors.onSurfaceLight,
        brightness: Brightness.light,
        outline: SColors.outlineLight,
      ),
      scaffoldBackgroundColor: SColors.backgroundLight,
      appBarTheme: SAppBarTheme.light,
      textTheme: STextTheme.light,
      outlinedButtonTheme: SOutlinedButtonTheme.light,
      filledButtonTheme: SFilledButtonTheme.light,
      iconButtonTheme: SIconButtonTheme.light,
      inputDecorationTheme: SInputDecorationTheme.light,
      progressIndicatorTheme: SProgressIndicatorTheme.light,
      switchTheme: SSwitchTheme.light,
      listTileTheme: SListTileTheme.light,
      expansionTileTheme: SExpansionTileTheme.light,
      tabBarTheme: STabTheme.light,
      iconTheme: const IconThemeData(
        color: SColors.onSurfaceLight,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: SColors.backgroundLight,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: SColors.primary,
        surface: SColors.surfaceDark,
        onSurface: SColors.onSurfaceDark,
        brightness: Brightness.dark,
        outline: SColors.outlineDark,
      ),
      scaffoldBackgroundColor: SColors.backgroundDark,
      appBarTheme: SAppBarTheme.dark,
      textTheme: STextTheme.dark,
      outlinedButtonTheme: SOutlinedButtonTheme.dark,
      filledButtonTheme: SFilledButtonTheme.dark,
      iconButtonTheme: SIconButtonTheme.dark,
      inputDecorationTheme: SInputDecorationTheme.dark,
      progressIndicatorTheme: SProgressIndicatorTheme.dark,
      switchTheme: SSwitchTheme.dark,
      listTileTheme: SListTileTheme.dark,
      expansionTileTheme: SExpansionTileTheme.dark,
      tabBarTheme: STabTheme.dark,
      iconTheme: const IconThemeData(
        color: SColors.onSurfaceDark,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: SColors.backgroundDark,
      ),
    );
  }

  static bool isLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }
}
