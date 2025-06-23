import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_drag_wrapper.dart';

abstract class BaseKeysBlock extends StatelessWidget {
  final KeyboardKeyBlock block;
  final double buttonSize;
  final KeyBindingMap? pageMap;
  final int? currentKeyCode;
  final void Function(BaseKeyData keyData)? onPressedButton;
  final void Function(int firstCode, int secondCode)? onSwapBindingData;

  const BaseKeysBlock({
    super.key,
    required this.block,
    this.buttonSize = 50,
    this.pageMap,
    this.currentKeyCode,
    this.onPressedButton,
    this.onSwapBindingData,
  });

  @override
  Widget build(BuildContext context);

  Widget buildKeyButton({
    required BaseKeyData keyData,
    double? width,
    double? height,
  }) {
    return KeyDragWrapper(
      keyCode: keyData.keyCode,
      width: width ?? buttonSize,
      height: height ?? buttonSize,
      onSwapBindingData: onSwapBindingData,
      childBuilder: (isHighlighted, feedbackButtonsSize) {
        return KeyButton(
          keyData: keyData,
          keyBindingData: pageMap?[keyData.keyCode.toString()],
          isSelected: currentKeyCode == keyData.keyCode,
          isHighlighted: isHighlighted,
          onPressed: () {
            onPressedButton?.call(keyData);
          },
          width: feedbackButtonsSize ?? (width ?? buttonSize),
          height: feedbackButtonsSize ?? (height ?? buttonSize),
        );
      },
    );
  }
}
