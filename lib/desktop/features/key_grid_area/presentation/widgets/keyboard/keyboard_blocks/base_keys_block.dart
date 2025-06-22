import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button.dart';

abstract class BaseKeysBlock extends StatelessWidget {
  final KeyboardKeyBlock block;
  final double buttonSize;
  final KeyBindingMap? pageMap;
  final int? currentKeyCode;
  final void Function(BaseKeyData keyData)? onPressedButton;

  const BaseKeysBlock({
    super.key,
    required this.block,
    this.buttonSize = 50,
    this.pageMap,
    this.currentKeyCode,
    this.onPressedButton,
  });

  @override
  Widget build(BuildContext context);

  KeyButton buildKeyButton({required BaseKeyData keyData}) {
    return KeyButton(
      keyData: keyData,
      keyBindingData: pageMap?[keyData.keyCode.toString()],
      isSelected: currentKeyCode == keyData.keyCode,
      onPressed: () {
        onPressedButton?.call(keyData);
      },
      size: buttonSize,
    );
  }
}
