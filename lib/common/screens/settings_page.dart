import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamkeys/android/providers/buttons_provider.dart';
import 'package:streamkeys/android/widgets/device_selection_tile.dart';
import 'package:streamkeys/common/widgets/change_theme_mode.dart';
import 'package:streamkeys/windows/providers/server_provider.dart';
import 'package:streamkeys/windows/widgets/obs_connection_form.dart';
import 'package:streamkeys/windows/widgets/startup_setting_tile.dart';

class SettingsPage extends StatelessWidget {
  final ButtonsProvider? actionsProvider;
  final ServerProvider? serverProvider;

  const SettingsPage({
    super.key,
    this.actionsProvider,
    this.serverProvider,
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: Platform.isWindows ? 385 : double.infinity,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildForOnlyAndroid(
                  DeviceSelectionTile(actionsProvider: actionsProvider),
                ),
                _buildThemeTile(),
                buildForOnlyWindows(
                  const StartupSettingTile(),
                ),
                buildForOnlyWindows(
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Divider(),
                      ),
                      ObsConnectionForm(provider: serverProvider!),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

  Widget buildForOnlyWindows(Widget widget) {
    if (Platform.isWindows) {
      return widget;
    }
    return const SizedBox();
  }
}
