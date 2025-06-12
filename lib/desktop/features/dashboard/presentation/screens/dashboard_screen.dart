import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/dashboard_tab_bar.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';
import 'package:streamkeys/desktop/features/grid_deck/presentation/screens/grid_deck_screen.dart';
import 'package:streamkeys/desktop/features/keyboard_deck/presentation/screens/keyboard_deck_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static final List<PageTab> tabs = <PageTab>[
    const GridDeckScreen(),
    const KeyboardDeckScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
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
            tabs: tabs,
            controller: _tabController,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((PageTab tab) => tab.pageView).toList(),
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
