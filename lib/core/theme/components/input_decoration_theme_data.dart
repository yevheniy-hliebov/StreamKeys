part of 'index.dart';

class AppInputDecorationThemeData {
  const AppInputDecorationThemeData._();

  static InputDecorationTheme getTheme(AppColorsData colors) {
    return InputDecorationTheme(
      filled: true,
      isDense: true,
      hoverColor: colors.surface,
      fillColor: colors.surface,
      activeIndicatorBorder: _getBorder(colors.outline).borderSide,
      enabledBorder: _getBorder(colors.outline),
      border: _getBorder(colors.outline),
      focusedBorder: _getBorder(colors.primary),
      labelStyle: AppTextTheme.theme.bodyMedium?.copyWith(color: colors.onSurface),
      hintStyle: AppTextTheme.theme.bodyMedium?.copyWith(color: colors.onSurface),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.xs,
      ),
    );
  }

  static InputBorder _getBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: BorderRadius.circular(5),
    );
  }
}
