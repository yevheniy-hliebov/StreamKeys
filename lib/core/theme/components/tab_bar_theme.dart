part of 'index.dart';

class AppTabThemeData {
  const AppTabThemeData._();

  static TabBarThemeData getTheme(AppColorsData colors) {
    return TabBarThemeData(
      dividerColor: Colors.transparent,
      dividerHeight: 0,
      labelColor: colors.onPrimary,
      unselectedLabelColor: colors.onSurface,
      labelStyle: AppTextTheme.theme.labelSmall,
      unselectedLabelStyle: AppTextTheme.theme.labelSmall,
      tabAlignment: TabAlignment.fill,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.transparent,
      indicator: BoxDecoration(color: colors.primary),
      // overlayColor: WidgetStatePropertyAll<Color>(colors.primary),
    );
  }
}
