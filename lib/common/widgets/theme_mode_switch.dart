import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';

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
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Switch(
      thumbIcon: WidgetStatePropertyAll<Icon>(
        Icon(Icons.light_mode, color: AppColors.of(context).onBackground),
      ),
      value: !isLightMode,
      onChanged: (bool isDarkMode) => _changeMode(isDarkMode),
    );
  }

  void _changeMode(bool isDarkMode) {
    final ThemeMode themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    onChanged?.call(themeMode);
  }
}