import 'package:flutter/material.dart';

class ThemeModeDialog extends StatelessWidget {
  final ThemeMode selectedThemeMode;
  final void Function(ThemeMode themeMode)? onChanged;

  const ThemeModeDialog({
    super.key,
    required this.selectedThemeMode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ThemeMode.values.map((themeMode) {
          return ListTile(
            title: Text(_getThemeModeString(context, themeMode)),
            onTap: () => _changeMode(context, themeMode),
            selected: selectedThemeMode == themeMode,
          );
        }).toList(),
      ),
      actions: _buildActions(context),
    );
  }

  String _getThemeModeString(BuildContext context, ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _changeMode(BuildContext context, ThemeMode themeMode) {
    onChanged?.call(themeMode);
    Navigator.of(context).pop();
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
    ];
  }
}