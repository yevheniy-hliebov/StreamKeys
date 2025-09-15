part of 'index.dart';

class AppOutlinedButtonThemeData {
  const AppOutlinedButtonThemeData._();

  static OutlinedButtonThemeData getTheme(AppColorsData colors) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.md,
          ),
        ),
        shape: WidgetStateProperty.all(_borderRadius),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return _borderSide(colors.outline.withValues(alpha: 0.6));
          }
          return _borderSide(colors.outline);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.onDisabled;
          }
          return colors.onBackground;
        }),
        textStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppTextTheme.theme.bodyMedium?.copyWith(
              color: colors.onDisabled,
            );
          }
          return AppTextTheme.theme.bodyMedium?.copyWith(
            color: colors.onBackground,
          );
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return colors.overlay;
          } else if (states.contains(WidgetState.disabled)) {
            return colors.disabledFill;
          }
          return Colors.transparent;
        }),
      ),
    );
  }

  static RoundedRectangleBorder get _borderRadius {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
  }

  static BorderSide _borderSide(Color color) {
    return BorderSide(color: color, width: 1);
  }
}
