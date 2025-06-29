part of 'index.dart';

class AppSwitchThemeData {
  const AppSwitchThemeData._();

  static SwitchThemeData getTheme(AppColorsData colors) {
    return SwitchThemeData(
      trackOutlineWidth: const WidgetStatePropertyAll(1),
      trackOutlineColor: WidgetStatePropertyAll(colors.outline),
      overlayColor: WidgetStatePropertyAll(
        colors.overlay.withValues(alpha: 0.3),
      ),
      thumbColor: WidgetStatePropertyAll(colors.surface),
      trackColor: WidgetStatePropertyAll(colors.background),
    );
  }
}