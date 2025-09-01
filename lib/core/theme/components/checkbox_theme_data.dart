part of 'index.dart';

class AppCheckboxThemeData {
  const AppCheckboxThemeData._();

  static CheckboxThemeData getTheme(AppColorsData colors) {
    return CheckboxThemeData(
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const BorderSide(color: Colors.transparent, width: 0);
        } else {
          return BorderSide(color: colors.onBackground, width: 2);
        }
      }),
    );
  }
}
