import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/settings/widgets/settings_tabs.dart';

class SettingPage extends StatelessWidget {
  final int initialTabIndex;

  const SettingPage({super.key, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Setting page'),
          backgroundColor: SColors.of(context).surface,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: Container(
              height: 4,
              color: SColors.of(context).outlineVariant,
            ),
          ),
        ),
        body: const SettingsTabs(),
      ),
    );
  }
}
