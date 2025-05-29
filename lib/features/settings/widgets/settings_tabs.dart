import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/settings/widgets/general_settings_tab_view.dart';

class SettingsTabs extends StatelessWidget {
  const SettingsTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: SColors.of(context).surface,
          child: const TabBar(
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'OBS'),
              Tab(text: 'Twitch'),
            ],
          ),
        ),
        const Expanded(
          child: TabBarView(
            children: [
              Center(child: GeneralSettingsTabView()),
              Center(child: Text('OBS Connection')),
              Center(child: Text('Twitch')),
            ],
          ),
        ),
      ],
    );
  }
}
