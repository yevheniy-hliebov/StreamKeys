import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/helpers/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/base_keys_block.dart';

class NavigationBlockMap extends BaseKeysBlock {
  const NavigationBlockMap({
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: For.generateChildren(
        block.length,
        generator: (int i) {
          final List<KeyboardKeyData> row = block[i];

          return <Widget>[
            if (i == 1) ...<Widget>[
              SizedBox(height: Spacing.keyGrid.btwBlock),
            ] else if (i == 3) ...<Widget>[const Spacer()] else if (i !=
                0) ...<Widget>[SizedBox(height: Spacing.keyGrid.btwKey)],
            Row(
              spacing: Spacing.keyGrid.btwKey,
              children: For.generateChildren(
                row.length,
                generator: (int colIndex) => <Widget>[
                  buildKeyButton(keyData: row[colIndex]),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
