import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamkeys/android/providers/actions_provider.dart';
import 'package:streamkeys/android/widgets/device_selection_tile.dart';
import 'package:streamkeys/common/widgets/change_theme_mode.dart';

class SettingsPage extends StatelessWidget {
  final ActionsProvider? actionsProvider;

  const SettingsPage({
    super.key,
    this.actionsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          buildForOnlyAndroid(
            DeviceSelectionTile(actionsProvider: actionsProvider),
          ),
          _buildThemeTile(),
        ],
      ),
    );
  }

  ListTile _buildThemeTile() {
    return ListTile(
      title: const Text(
        'Theme mode',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Transform.translate(
        offset: const Offset(14, 0),
        child: const ChangeThemeMode(),
      ),
    );
  }

  Widget buildForOnlyAndroid(Widget widget) {
    if (Platform.isAndroid) {
      return widget;
    }
    return const SizedBox();
  }
}
