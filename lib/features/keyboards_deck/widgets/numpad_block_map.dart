import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/keyboard_button.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_key.dart';

class NumpadBlockMap extends StatelessWidget {
  const NumpadBlockMap({
    super.key,
    required this.block,
  });

  final List<List<KeyboardKey>> block;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 174,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: For.generateWidgets(
              block.length,
              generator: (i) {
                final row = block[i];
                if (i == block.length - 1) {
                  return [const SizedBox()];
                }
                return [
                  if (i == 0) ...[
                    const SizedBox(height: 66),
                  ] else ...[
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: For.generateWidgets(
                      row.length,
                      generator: (j) => [
                        if (j != 0) ...[
                          const SizedBox(width: 12),
                        ],
                        if (row[j].name == 'num lock') ...[
                          IgnorePointer(
                            ignoring: true,
                            child: Opacity(
                              opacity: 0.2,
                              child: KeyboardButton(
                                keyboardKey: row[j],
                              ),
                            ),
                          ),
                        ] else if (j == 0) ...[
                          Expanded(
                            child: KeyboardButton(
                              keyboardKey: row[j],
                            ),
                          ),
                        ] else ...[
                          KeyboardButton(
                            keyboardKey: row[j],
                          ),
                        ]
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Builder(
          builder: (context) {
            if (block.isEmpty) {
              return const SizedBox();
            }
            final column = block.last;
            return Container(
              height: 298,
              margin: const EdgeInsets.only(top: 66),
              child: Column(
                children: For.generateWidgets(
                  column.length,
                  generator: (i) {
                    return [
                      if (i != 0) ...[
                        const SizedBox(height: 12),
                      ],
                      if (i > 2) ...[
                        Expanded(
                          child: KeyboardButton(
                            keyboardKey: column[i],
                          ),
                        ),
                      ] else ...[
                        KeyboardButton(
                          keyboardKey: column[i],
                        ),
                      ]
                    ];
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
