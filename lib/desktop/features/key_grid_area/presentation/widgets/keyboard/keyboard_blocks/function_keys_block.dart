import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/base_keys_block.dart';

class FunctionKeysBlock extends BaseKeysBlock {
  const FunctionKeysBlock({
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
    final List<int> indexsAfterSpace = <int>[1, 5, 9];
    final List<KeyboardKeyData> row = block[0];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: For.generateChildren(
        row.length,
        generator: (int index) {
          return <Widget>[
            if (indexsAfterSpace.contains(index)) ...<Widget>[
              SizedBox(width: Spacing.keyGrid.btwSections),
            ] else if (index != 0) ...<Widget>[
              SizedBox(width: Spacing.keyGrid.btwKey),
            ],
            buildKeyButton(keyData: row[index]),
          ];
        },
      ),
    );
  }
}
