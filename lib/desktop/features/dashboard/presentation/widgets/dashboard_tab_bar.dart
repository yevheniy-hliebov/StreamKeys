import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';

class DashboardTabBar extends StatelessWidget {
  final List<PageTab> tabs;
  final TabController? controller;

  const DashboardTabBar({
    super.key,
    required this.tabs,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      tabs: tabs.map((PageTab tab) {
        return Tab(
          height: 35,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: <Widget>[
              Icon(tab.iconData, size: 18),
              Text(tab.label),
            ],
          ),
        );
      }).toList(),
    );
  }
}
