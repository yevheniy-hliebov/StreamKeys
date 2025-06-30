import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/page_tab.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/keyboard_list.dart';

class HidMacrosScreen extends StatelessWidget with PageTab {
  const HidMacrosScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'HID Macros';

  @override
  Widget get icon => const SizedBox();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(Spacing.md),
            constraints: const BoxConstraints(maxWidth: 400),
            child: const KeyboardList(),
          ),
        ],
      ),
    );
  }
}
