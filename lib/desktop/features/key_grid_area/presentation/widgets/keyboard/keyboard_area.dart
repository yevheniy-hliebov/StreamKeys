import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/repositories/keyboard_map_repository.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/base_keys_block.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/function_keys_block.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/main_keys_block.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/navigation_block_map.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_blocks/numpad_keys_block.dart';

class KeyboardArea extends StatelessWidget {
  final double buttonSize;
  final KeyboardType keyboardType;
  final Map<String, KeyboardKeyBlock> keyMap;
  final KeyBindingMap? pageMap;
  final int? currentKeyCode;
  final void Function(BaseKeyData keyData)? onPressedButton;
  final void Function(int firstCode, int secondCode)? onSwapBindingData;

  const KeyboardArea({
    super.key,
    this.buttonSize = 50,
    this.keyboardType = KeyboardType.full,
    required this.keyMap,
    this.pageMap,
    this.currentKeyCode,
    this.onPressedButton,
    this.onSwapBindingData,
  });

  @override
  Widget build(BuildContext context) {
    if (keyMap.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final KeyboardKeyBlock functionBlock =
        keyMap[KeyboardMapRepository.functionsBlockKey]!;
    final KeyboardKeyBlock mainBlock =
        keyMap[KeyboardMapRepository.mainBlockKey]!;
    final KeyboardKeyBlock navigationBlock =
        keyMap[KeyboardMapRepository.navigationBlockKey]!;
    final KeyboardKeyBlock numpadBlock =
        keyMap[KeyboardMapRepository.numpadBlockKey]!;

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
    final double maxWidth = (buttonSize * keyCount) +
        (Spacing.keyGrid.btwKey * (keyCount - 4)) +
        3 * Spacing.keyGrid.btwSections;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.keyGrid.btwBlock,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildBlock(FunctionKeysBlock.new, functionBlock),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: _buildBlock(MainKeysBlock.new, mainBlock),
        ),
      ],
    );
  }

  Widget _buildNavigationSection(
    KeyboardKeyBlock mainBlock,
    KeyboardKeyBlock navBlock,
  ) {
    final double height = buttonSize +
        Spacing.keyGrid.btwBlock +
        buttonSize * mainBlock.length +
        Spacing.keyGrid.btwKey * (mainBlock.length - 1);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height),
      child: _buildBlock(NavigationBlockMap.new, navBlock),
    );
  }

  Widget _buildNumpadSection(
    KeyboardKeyBlock mainBlock,
    KeyboardKeyBlock numpadBlock,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: buttonSize + Spacing.keyGrid.btwBlock),
      child: _buildBlock(NumpadKeysBlock.new, numpadBlock),
    );
  }

  T _buildBlock<T extends BaseKeysBlock>(
    T Function({
      required KeyboardKeyBlock block,
      required double buttonSize,
      KeyBindingMap? pageMap,
      int? currentKeyCode,
      void Function(BaseKeyData keyData)? onPressedButton,
      void Function(int firstCode, int secondCode)? onSwapBindingData,
    }) builder,
    KeyboardKeyBlock block,
  ) {
    return builder(
      block: block,
      buttonSize: buttonSize,
      pageMap: pageMap,
      currentKeyCode: currentKeyCode,
      onPressedButton: onPressedButton,
      onSwapBindingData: onSwapBindingData,
    );
  }
}
