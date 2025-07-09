import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/helpers/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/base_keys_block.dart';

class MainKeysBlock extends BaseKeysBlock {
  const MainKeysBlock({
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
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;

      return Column(
        spacing: Spacing.keyGrid.btwKey,
        children: For.generateChildren(
          block.length,
          generator: (int index) {
            final List<KeyboardKeyData> row = block[index];
            return <Widget>[
              Row(
                spacing: Spacing.keyGrid.btwKey,
                children: For.generateChildren(
                  row.length,
                  generator: (int colIndex) {
                    return <Widget>[
                      _buildButton(maxWidth, row, index, colIndex),
                    ];
                  },
                ),
              )
            ];
          },
        ),
      );
    });
  }

  Widget _buildButton(
    double maxWidth,
    List<KeyboardKeyData> row,
    int index,
    int colIndex,
  ) {
    final int lastRowIndex = block.length - 1;

    final bool isSpaceKey = index == lastRowIndex && colIndex == 3;
    final bool isEdgeKey = index != lastRowIndex &&
        (colIndex == row.length - 1 || (index != 0 && colIndex == 0));

    final rowLength = row.length;
    final totalWidthButtons =
        rowLength * buttonSize + (rowLength - 1) * Spacing.keyGrid.btwKey;
    final remaining = maxWidth - totalWidthButtons;
    double? buttonWidth;

    if (isSpaceKey) {
      buttonWidth = remaining + buttonSize;
    }
    if (isEdgeKey) {
      if (index == 0 && colIndex == row.length - 1) {
        buttonWidth = remaining + buttonSize;
      } else {
        buttonWidth = remaining / 2 + buttonSize;
      }
    }

    return buildKeyButton(
      keyData: row[colIndex],
      width: buttonWidth,
    );
  }
}
