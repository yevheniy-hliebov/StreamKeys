part of 'index.dart';

class AppIconButtonThemeData {
  const AppIconButtonThemeData._();

  static IconButtonThemeData getTheme(AppColorsData colors) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colors.onBackground,
      ),
    );
  }
}
