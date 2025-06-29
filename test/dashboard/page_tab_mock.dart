import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/page_tab.dart';

class PageTabMock extends StatelessWidget with PageTab {
  @override
  Widget get pageView => this;

  @override
  final String label;

  @override
  final Widget icon;

  const PageTabMock({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Page: $label');
  }
}
