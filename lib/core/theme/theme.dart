import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/theme/components/index.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light = _getTheme(AppColors.light, Brightness.light);
  static ThemeData dark = _getTheme(AppColors.dark, Brightness.dark);

  static ThemeData _getTheme(AppColorsData colors, Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: colors.primary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        outline: colors.outline,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: colors.background,
      tabBarTheme: AppTabThemeData.getTheme(colors),
      iconButtonTheme: AppIconButtonThemeData.getTheme(colors),
      iconTheme: IconThemeData(color: colors.onBackground),
      progressIndicatorTheme: AppProgressIndicatorTheme.getTheme(colors),
      inputDecorationTheme: AppInputDecorationThemeData.getTheme(colors),
      outlinedButtonTheme: AppOutlinedButtonThemeData.getTheme(colors),
      filledButtonTheme: AppFilledButtonThemeData.getTheme(colors),
      switchTheme: AppSwitchThemeData.getTheme(colors),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.background,
        titleTextStyle: AppTextTheme.theme.bodyLarge,
        contentTextStyle: AppTextTheme.theme.bodyMedium,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.background,
        menuPadding: EdgeInsets.zero,
        labelTextStyle: WidgetStatePropertyAll(AppTextTheme.theme.bodyMedium),
      ),
      checkboxTheme: AppCheckboxThemeData.getTheme(colors),
      textTheme: AppTextTheme.theme,
      listTileTheme: ListTileThemeData(
        titleTextStyle: AppTextTheme.theme.labelSmall,
      ),
    );
  }
}
