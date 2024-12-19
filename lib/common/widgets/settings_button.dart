import 'package:flutter/material.dart';
import 'package:streamkeys/android/providers/buttons_provider.dart';
import 'package:streamkeys/common/screens/settings_page.dart';
import 'package:streamkeys/windows/providers/server_provider.dart';

class SettingsButton extends StatelessWidget {
  final ButtonsProvider? actionsProvider;
  final ServerProvider? serverProvider;

  const SettingsButton({
    super.key,
    this.actionsProvider,
    this.serverProvider,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _pushToSettingPage(context),
      icon: const Icon(Icons.settings),
    );
  }

  void _pushToSettingPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          actionsProvider: actionsProvider,
          serverProvider: serverProvider,
        ),
      ),
    );
  }
}
