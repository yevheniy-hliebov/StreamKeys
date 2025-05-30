import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/keyboard_button.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_key.dart';

class NavigationBlockMap extends StatelessWidget {
  const NavigationBlockMap({
    super.key,
    required this.block,
  });

  final List<List<KeyboardKey>> block;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 364,
      child: Column(
        children: For.generateWidgets(
          block.length,
          generator: (i) {
            final row = block[i];
            return [
              if (i == 1) ...[
                const SizedBox(height: 16),
              ] else if (i == 3) ...[
                const Spacer(),
              ] else if (i != 0) ...[
                const SizedBox(height: 12),
              ],
              Row(
                children: For.generateWidgets(
                  row.length,
                  generator: (j) => [
                    if (j != 0) ...[
                      const SizedBox(width: 12),
                    ],
                    KeyboardButton(
                      keyboardKey: row[j],
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}
