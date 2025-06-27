import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/dashboard_tab_bar.dart';
import 'package:streamkeys/common/widgets/page_tab.dart';

class DashboardScreen extends StatefulWidget {
  final List<PageTab> tabs;

  const DashboardScreen({
    super.key,
    required this.tabs,
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
        child: Container(
          decoration: _boxDecoration(context),
          child: DashboardTabBar(
            tabs: widget.tabs,
            controller: _tabController,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.tabs.map((PageTab tab) => tab.pageView).toList(),
      ),
    );
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 4,
          color: AppColors.of(context).outlineVariant,
        ),
      ),
    );
  }
}
