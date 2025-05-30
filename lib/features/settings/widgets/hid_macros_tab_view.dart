import 'package:flutter/material.dart';
import 'package:streamkeys/features/hid_macros/widgets/keyboard_list.dart';

class HidMacrosTabView extends StatelessWidget {
  static const String tabName = 'HID Macros';

  const HidMacrosTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const KeyboardList(),
        ),
      ),
    );
  }
}
