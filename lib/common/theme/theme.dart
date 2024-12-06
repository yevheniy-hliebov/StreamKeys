import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/common/theme/custom/app_bar_theme.dart';
import 'package:streamkeys/common/theme/custom/expansion_tile.dart';
import 'package:streamkeys/common/theme/custom/icon_button_theme.dart';
import 'package:streamkeys/common/theme/custom/input_decoration_theme.dart';
import 'package:streamkeys/common/theme/custom/list_tile_theme.dart';
import 'package:streamkeys/common/theme/custom/outlined_button_theme.dart';
import 'package:streamkeys/common/theme/custom/progress_indicator_theme.dart';
import 'package:streamkeys/common/theme/custom/switch_theme.dart';
import 'package:streamkeys/common/theme/custom/tab_theme.dart';
import 'package:streamkeys/common/theme/custom/text_theme.dart';

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
      iconButtonTheme: SIconButtonTheme.light,
      inputDecorationTheme: SInputDecorationTheme.light,
      progressIndicatorTheme: SProgressIndicatorTheme.light,
      switchTheme: SSwitchTheme.light,
      listTileTheme: SListTileTheme.light,
      expansionTileTheme: SExpansionTileTheme.light,
      tabBarTheme: STabTheme.light,
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
      iconButtonTheme: SIconButtonTheme.dark,
      inputDecorationTheme: SInputDecorationTheme.dark,
      progressIndicatorTheme: SProgressIndicatorTheme.dark,
      switchTheme: SSwitchTheme.dark,
      listTileTheme: SListTileTheme.dark,
      expansionTileTheme: SExpansionTileTheme.dark,
      tabBarTheme: STabTheme.dark,
    );
  }

  static bool isLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }
}
