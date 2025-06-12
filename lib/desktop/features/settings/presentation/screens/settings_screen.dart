import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';

class SettingsScreen extends StatelessWidget with PageTab {
  const SettingsScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'Settings';

  @override
  IconData get iconData => Icons.settings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label),
    );
  }
}
