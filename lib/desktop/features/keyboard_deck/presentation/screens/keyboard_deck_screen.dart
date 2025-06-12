import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';

class KeyboardDeckScreen extends StatelessWidget with PageTab {
  const KeyboardDeckScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'Keyboard Deck';

  @override
  IconData get iconData => Icons.keyboard_outlined;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label),
    );
  }
}
