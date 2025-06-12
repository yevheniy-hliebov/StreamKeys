import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';

class GridDeckScreen extends StatelessWidget with PageTab {
  const GridDeckScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'Grid Deck';

  @override
  IconData get iconData => Icons.grid_view;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label),
    );
  }
}
