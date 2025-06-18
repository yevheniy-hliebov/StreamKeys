import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/repositories/keyboard_map_repository.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/function_keys_block.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/main_keys_block.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/navigation_block_map.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/numpad_keys_block.dart';

class KeyboardArea extends StatelessWidget {
  final Map<String, KeyboardKeyBlock> map;
  const KeyboardArea({
    super.key,
    required this.map,
  });

  @override
  Widget build(BuildContext context) {
    if (map.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final KeyboardKeyBlock functionKeysBlock =
        map[KeyboardMapRepository.functionsBlockKey]!;
    final KeyboardKeyBlock mainKeysBlock =
        map[KeyboardMapRepository.mainBlockKey]!;
    final KeyboardKeyBlock navigationKeysBlock =
        map[KeyboardMapRepository.navigationBlockKey]!;
    final KeyboardKeyBlock numpadKeysBlock =
        map[KeyboardMapRepository.numpadBlockKey]!;

    final double maxWidthMainblock = (50.0 * functionKeysBlock[0].length) +
        (Spacing.keyGrid.btwKey * (functionKeysBlock[0].length - 4)) +
        3 * Spacing.keyGrid.btwSections;

    return Row(
      spacing: Spacing.keyGrid.btwBlock,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.keyGrid.btwBlock,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FunctionKeysBlock(block: functionKeysBlock),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidthMainblock,
              ),
              child: MainKeysBlock(block: mainKeysBlock),
            )
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 50 +
                Spacing.keyGrid.btwBlock +
                50 * mainKeysBlock.length +
                Spacing.keyGrid.btwKey * (mainKeysBlock.length - 1),
          ),
          child: NavigationBlockMap(block: navigationKeysBlock),
        ),
        Padding(
          padding: EdgeInsets.only(top: 50 + Spacing.keyGrid.btwBlock),
          child: NumpadKeysBlock(block: numpadKeysBlock),
        )
      ],
    );
  }
}
