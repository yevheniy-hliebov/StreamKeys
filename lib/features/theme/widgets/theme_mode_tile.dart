import 'package:flutter/material.dart';
import 'package:streamkeys/features/theme/widgets/theme_mode_dialog.dart';

class ThemeModeTile extends StatelessWidget {
  final ThemeMode selectedThemeMode;
  final void Function(ThemeMode)? onChanged;

  const ThemeModeTile({
    super.key,
    required this.selectedThemeMode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Change theme'),
      onTap: () => _showDialog(context),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ThemeModeDialog(
          selectedThemeMode: selectedThemeMode,
          onChanged: (themeMode) {
            onChanged?.call(themeMode);
          },
        );
      },
    );
  }
}
