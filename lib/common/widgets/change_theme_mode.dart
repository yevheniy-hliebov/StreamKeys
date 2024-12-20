import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/common/theme/theme.dart';
import 'package:streamkeys/common/theme/theme_provider.dart';

class ChangeThemeMode extends StatelessWidget {
  const ChangeThemeMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      final isLight = STheme.isLight(context);
      return Transform.scale(
        scale: 0.8,
        child: Switch(
          thumbIcon: getIcon(isLight),
          value: !isLight,
          onChanged: (value) => provider.setModeByBool(value),
        ),
      );
    });
  }

  WidgetStatePropertyAll<Icon> getIcon(bool isLightMode) {
    if (isLightMode) {
      return const WidgetStatePropertyAll(
          Icon(Icons.light_mode, color: SColors.onBackgroundDark));
    }
    return const WidgetStatePropertyAll(
        Icon(Icons.dark_mode, color: SColors.onBackgroundLight));
  }
}
