import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_devider.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/hid_macros_controls_panel.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/hid_macros_keyboard_panel.dart';

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
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HidMacrosControlsPanel(),
            ],
          ),
        ),
        DeckDevider(axis: Axis.vertical),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HidMacrosKeyboardPanel(),
            ],
          ),
        ),
      ],
    );
  }
}
