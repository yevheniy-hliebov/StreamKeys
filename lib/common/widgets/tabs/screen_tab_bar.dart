import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';

class ScreenTabBar extends StatelessWidget {
  final List<PageTab> tabs;
  final TabController? controller;

  const ScreenTabBar({
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
              tab.icon,
              Text(tab.label),
            ],
          ),
        );
      }).toList(),
    );
  }
}
