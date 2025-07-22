import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/containers/bottom_border_container.dart';
import 'package:streamkeys/common/widgets/containers/status_overlay.dart';
import 'package:streamkeys/common/widgets/tabs/screen_tab_bar.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';

class DashboardScreen extends StatefulWidget {
  final List<PageTab> tabs;
  final List<Widget> statusWidgets;
  final void Function(BuildContext context)? onInit;

  const DashboardScreen({
    super.key,
    required this.tabs,
    this.statusWidgets = const [],
    this.onInit,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onInit?.call(context);
      }
    });
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
        child: BottomBorderContainer(
          child: ScreenTabBar(tabs: widget.tabs, controller: _tabController),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.tabs.map((PageTab tab) => tab.pageView).toList(),
      ),
      bottomNavigationBar: StatusOverlay(children: widget.statusWidgets),
    );
  }
}
