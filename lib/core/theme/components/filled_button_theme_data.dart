part of 'index.dart';

class AppFilledButtonThemeData {
  const AppFilledButtonThemeData._();

  static FilledButtonThemeData getTheme(AppColorsData colors) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: AppTextTheme.theme.bodyMedium,
        shape: _borderRadius,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
      ),
    );
  }

  static RoundedRectangleBorder get _borderRadius {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
  }
}
