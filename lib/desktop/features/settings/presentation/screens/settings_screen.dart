import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/screen_tab_bar.dart';
import 'package:streamkeys/common/widgets/page_tab.dart';

class SettingsScreen extends StatefulWidget with PageTab {
  final List<PageTab> tabs;

  const SettingsScreen({
    super.key,
    required this.tabs,
  });

  @override
  Widget get pageView => this;

  @override
  String get label => 'Settings';

  @override
  Widget get icon => const Icon(Icons.settings, size: 18);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: ScreenTabBar(
          tabs: widget.tabs,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.tabs.map((PageTab tab) => tab.pageView).toList(),
      ),
    );
  }
}
