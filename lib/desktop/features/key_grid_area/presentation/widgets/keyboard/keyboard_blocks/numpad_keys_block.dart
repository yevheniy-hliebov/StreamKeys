import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button.dart';

class NumpadKeysBlock extends StatelessWidget {
  final KeyboardKeyBlock block;

  const NumpadKeysBlock({
    super.key,
    required this.block,
  });

  @override
  Widget build(BuildContext context) {
    final int lastRowIndex = block.length - 1;

    return Row(
      spacing: Spacing.keyGrid.btwKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: block[0].length * 50 +
                Spacing.keyGrid.btwKey * (block[0].length - 1),
          ),
          child: Column(
            spacing: Spacing.keyGrid.btwKey,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: For.generateChildren(
              block.length,
              generator: (int index) {
                final List<KeyboardKeyData> row = block[index];

                if (index == lastRowIndex) {
                  return <Widget>[];
                }

                return <Widget>[
                  Row(
                    spacing: Spacing.keyGrid.btwKey,
                    children: For.generateChildren(
                      row.length,
                      generator: (int colIndex) => <Widget>[
                        if (colIndex == row.length - 1) ...<Widget>[
                          Expanded(child: KeyButton(keyData: row[colIndex])),
                        ] else ...<Widget>[
                          KeyButton(keyData: row[colIndex]),
                        ],
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: (block.length - 1) * 50 +
                Spacing.keyGrid.btwKey * (block.length - 2),
          ),
          child: Column(
            spacing: Spacing.keyGrid.btwKey,
            children: For.generateChildren(
              block[lastRowIndex].length,
              generator: (int index) {
                final List<KeyboardKeyData> row = block[lastRowIndex];
                return <Widget>[
                  if (index == row.length - 1) ...<Widget>[
                    Expanded(child: KeyButton(keyData: row[index])),
                  ] else ...<Widget>[
                    KeyButton(keyData: row[index]),
                  ],
                ];
              },
            ),
          ),
        ),
      ],
    );
  }
}
