import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/service_locator.dart';

class HidMacrosControlPanel extends StatelessWidget {
  const HidMacrosControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final hidmacros = sl<HidMacrosService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(child: FieldLabel('HID Macros')),
        const SizedBox(height: Spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: hidmacros.process.start,
              child: const Text('Start'),
            ),
            const SizedBox(width: Spacing.xs),
            OutlinedButton(
              onPressed: () => hidmacros.process.restart(shouldStart: true),
              child: const Text('Restart'),
            ),
            const SizedBox(width: Spacing.xs),
            OutlinedButton(
              onPressed: hidmacros.process.stop,
              child: const Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }
}
