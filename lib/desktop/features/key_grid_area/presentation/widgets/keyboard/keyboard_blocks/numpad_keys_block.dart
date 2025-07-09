import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/helpers/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/base_keys_block.dart';

class NumpadKeysBlock extends BaseKeysBlock {
  const NumpadKeysBlock({
    super.key,
    required super.block,
    super.buttonSize,
    super.pageMap,
    super.currentKeyCode,
    super.onPressedButton,
    super.onAddBindingAction,
    super.onSwapBindingData,
  });

  @override
  Widget build(BuildContext context) {
    final int lastRowIndex = block.length - 1;

    return Row(
      spacing: Spacing.keyGrid.btwKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
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

              final bool isLastRowNumpad = index == lastRowIndex - 1;
              return <Widget>[
                Row(
                  spacing: Spacing.keyGrid.btwKey,
                  children: For.generateChildren(
                    row.length,
                    generator: (int colIndex) => <Widget>[
                      if (isLastRowNumpad &&
                          colIndex == row.length - 1) ...<Widget>[
                        buildKeyButton(
                            keyData: row[colIndex],
                            width: buttonSize * 2 + Spacing.keyGrid.btwKey),
                      ] else ...<Widget>[
                        buildKeyButton(keyData: row[colIndex]),
                      ],
                    ],
                  ),
                ),
              ];
            },
          ),
        ),
        Column(
          spacing: Spacing.keyGrid.btwKey,
          children: For.generateChildren(
            block[lastRowIndex].length,
            generator: (int index) {
              final List<KeyboardKeyData> row = block[lastRowIndex];
              return <Widget>[
                if (index == row.length - 1) ...<Widget>[
                  buildKeyButton(
                      keyData: row[index],
                      height: buttonSize * 2 + Spacing.keyGrid.btwKey),
                ] else ...<Widget>[
                  buildKeyButton(keyData: row[index]),
                ],
              ];
            },
          ),
        ),
      ],
    );
  }
}
