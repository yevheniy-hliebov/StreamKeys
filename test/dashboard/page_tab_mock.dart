import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';

class PageTabMock extends StatelessWidget with PageTab {
  @override
  Widget get pageView => this;

  @override
  final String label;

  @override
  final IconData iconData;

  const PageTabMock({
    super.key,
    required this.label,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Page: $label');
  }
}
