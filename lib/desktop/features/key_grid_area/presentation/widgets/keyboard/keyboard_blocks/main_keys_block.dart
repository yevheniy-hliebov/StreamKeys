import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button.dart';

class MainKeysBlock extends StatelessWidget {
  final KeyboardKeyBlock block;

  const MainKeysBlock({
    super.key,
    required this.block,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      constraints: const BoxConstraints(maxWidth: 920),
      child: Column(
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
                      _buildButton(row, index, colIndex),
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

  Widget _buildButton(List<KeyboardKeyData> row, int index, int colIndex) {
    final int lastRowIndex = block.length - 1;

    final bool isSpaceKey = index == lastRowIndex && colIndex == 3;
    final bool isEdgeKey = index != lastRowIndex &&
        (colIndex == row.length - 1 || (index != 0 && colIndex == 0));

    if (isSpaceKey || isEdgeKey) {
      return Expanded(
        child: KeyButton(keyData: row[colIndex]),
      );
    }

    return KeyButton(keyData: row[colIndex]);
  }
}
