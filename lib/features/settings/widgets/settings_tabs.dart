import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/settings/widgets/general_settings_tab_view.dart';
import 'package:streamkeys/features/settings/widgets/hid_macros_tab_view.dart';
import 'package:streamkeys/features/settings/widgets/obs_tab_view.dart';

class SettingsTabs extends StatefulWidget {
  const SettingsTabs({super.key});

  @override
  State<SettingsTabs> createState() => _SettingsTabsState();
}

class _SettingsTabsState extends State<SettingsTabs>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: SColors.of(context).surface,
          child: TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: GeneralSettingsTabView.tabName),
              Tab(text: ObsTabView.tabName),
              Tab(text: HidMacrosTabView.tabName),
              Tab(text: 'Twitch'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              Center(child: GeneralSettingsTabView()),
              Center(child: ObsTabView()),
              Center(child: HidMacrosTabView()),
              Center(child: Text('Twitch')),
            ],
          ),
        ),
      ],
    );
  }
}
