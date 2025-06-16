part of 'index.dart';

class AppProgressIndicatorTheme {
  const AppProgressIndicatorTheme._();

  static ProgressIndicatorThemeData getTheme(AppColorsData colors) {
    return ProgressIndicatorThemeData(
      color: colors.primary,
      circularTrackColor: Colors.transparent,
      refreshBackgroundColor: colors.surface,
      linearTrackColor: colors.primary.withValues(alpha: 0.2),
      linearMinHeight: 1,
      strokeWidth: 3,
      constraints: const BoxConstraints(
        minWidth: 25,
        minHeight: 25,
      )
    );
  }
}