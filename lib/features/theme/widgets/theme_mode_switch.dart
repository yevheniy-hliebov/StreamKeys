import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';

class ThemeModeSwitch extends StatelessWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode themeMode)? onChanged;

  const ThemeModeSwitch({
    super.key,
    required this.themeMode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isLightMode = themeMode == ThemeMode.light;
    return Switch(
      thumbIcon: _getIcon(isLightMode),
      value: !isLightMode,
      onChanged: (isDarkMode) => changeMode(isDarkMode),
    );
  }

  WidgetStatePropertyAll<Icon> _getIcon(bool isLightMode) {
    if (isLightMode) {
      return const WidgetStatePropertyAll(
        Icon(Icons.light_mode, color: SColors.onBackgroundDark),
      );
    }
    return const WidgetStatePropertyAll(
      Icon(Icons.dark_mode, color: SColors.onBackgroundLight),
    );
  }

  void changeMode(bool isDarkMode) {
    final themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    onChanged?.call(themeMode);
  }
}