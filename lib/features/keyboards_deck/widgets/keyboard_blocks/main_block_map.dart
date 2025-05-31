import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/keyboard_button.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_key.dart';

class MainBlockMap extends StatelessWidget {
  const MainBlockMap({
    super.key,
    required this.block,
  });

  final List<List<KeyboardKey>> block;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      constraints: const BoxConstraints(maxWidth: 920),
      child: Column(
        children: For.generateWidgets(
          block.length,
          generator: (i) {
            final row = block[i];
            return [
              if (i != 0) ...[
                const SizedBox(height: 12),
              ],
              Row(
                children: For.generateWidgets(
                  row.length,
                  generator: (j) {
                    return [
                      if (j != 0) ...[
                        const SizedBox(width: 12),
                      ],
                      if (i == block.length - 1 && j == 3) ...[
                        Expanded(
                          child: KeyboardButton(
                            keyboardKey: row[j],
                          ),
                        ),
                      ] else if (i != block.length - 1 &&
                          (j == row.length - 1 || (i != 0 && j == 0))) ...[
                        Expanded(
                          child: KeyboardButton(
                            keyboardKey: row[j],
                          ),
                        ),
                      ] else ...[
                        KeyboardButton(
                          keyboardKey: row[j],
                        ),
                      ],
                    ];
                  },
                ),
              )
            ];
          },
        ),
      ),
    );
  }
}
