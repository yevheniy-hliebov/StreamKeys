import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/repositories/keyboard_map_repository.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/function_keys_block.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/main_keys_block.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/navigation_block_map.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/numpad_keys_block.dart';

class KeyboardArea extends StatelessWidget {
  final KeyboardType keyboardType;
  final Map<String, KeyboardKeyBlock> map;

  const KeyboardArea({
    super.key,
    this.keyboardType = KeyboardType.full,
    required this.map,
  });

  @override
  Widget build(BuildContext context) {
    if (map.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final KeyboardKeyBlock functionBlock =
        map[KeyboardMapRepository.functionsBlockKey]!;
    final KeyboardKeyBlock mainBlock = map[KeyboardMapRepository.mainBlockKey]!;
    final KeyboardKeyBlock navigationBlock =
        map[KeyboardMapRepository.navigationBlockKey]!;
    final KeyboardKeyBlock numpadBlock =
        map[KeyboardMapRepository.numpadBlockKey]!;

    return Row(
      spacing: Spacing.keyGrid.btwBlock,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (keyboardType.isFull || keyboardType.isCompact)
          _buildMainSection(functionBlock, mainBlock),
        if (keyboardType.isFull || keyboardType.isCompact)
          _buildNavigationSection(mainBlock, navigationBlock),
        if (keyboardType.isFull || keyboardType.isNumpad)
          _buildNumpadSection(mainBlock, numpadBlock),
      ],
    );
  }

  Widget _buildMainSection(
    KeyboardKeyBlock functionBlock,
    KeyboardKeyBlock mainBlock,
  ) {
    final int keyCount = functionBlock[0].length;
    final double maxWidth = (50.0 * keyCount) +
        (Spacing.keyGrid.btwKey * (keyCount - 4)) +
        3 * Spacing.keyGrid.btwSections;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.keyGrid.btwBlock,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FunctionKeysBlock(block: functionBlock),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: MainKeysBlock(block: mainBlock),
        ),
      ],
    );
  }

  Widget _buildNavigationSection(
    KeyboardKeyBlock mainBlock,
    KeyboardKeyBlock navBlock,
  ) {
    final double height = 50 +
        Spacing.keyGrid.btwBlock +
        50 * mainBlock.length +
        Spacing.keyGrid.btwKey * (mainBlock.length - 1);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height),
      child: NavigationBlockMap(block: navBlock),
    );
  }

  Widget _buildNumpadSection(
    KeyboardKeyBlock mainBlock,
    KeyboardKeyBlock numpadBlock,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 50 + Spacing.keyGrid.btwBlock),
      child: NumpadKeysBlock(block: numpadBlock),
    );
  }
}
