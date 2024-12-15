import 'package:flutter/material.dart';
import 'package:streamkeys/android/providers/buttons_provider.dart';
import 'package:streamkeys/common/screens/settings_page.dart';
import 'package:streamkeys/windows/providers/obs_connection_provider.dart';

class SettingsButton extends StatelessWidget {
  final ButtonsProvider? actionsProvider;
  final ObsConnectionProvider? obsConnectionProvider;

  const SettingsButton({
    super.key,
    this.actionsProvider,
    this.obsConnectionProvider,
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
          obsConnectionProvider: obsConnectionProvider,
        ),
      ),
    );
  }
}
