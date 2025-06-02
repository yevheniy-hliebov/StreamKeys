import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/base_key_button.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/key_positioned_label.dart';

class KeyboardButton extends StatelessWidget {
  final KeyboardKey keyboardKey;
  final KeyboardKeyData? keyData;
  final void Function()? onTap;
  final bool isSelected;
  final bool isDragHighlighted;
  final double size;

  const KeyboardButton({
    super.key,
    required this.keyboardKey,
    this.keyData,
    this.isSelected = false,
    this.isDragHighlighted = false,
    this.onTap,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    String tooltipMessage = keyboardKey.name.toUpperCase();
    if (keyData != null && keyData!.name.isNotEmpty) {
      tooltipMessage = keyData!.name;
    }

    return BaseKeyButton(
      size: size,
      tooltipMessage: tooltipMessage,
      onTap: onTap,
      backgroundColor:
          keyData?.backgroundColor ?? SColors.of(context).background,
      isSelected: isSelected,
      isDragHighlighted: isDragHighlighted,
      child: _buildChild(),
    );
  }

  static Map<String, IconData> iconButons = {
    'up': Icons.arrow_upward,
    'down': Icons.arrow_downward,
    'left': Icons.arrow_back,
    'right': Icons.arrow_forward,
    'backspace': Icons.arrow_back,
  };

  Widget _buildChild() {
    if (keyData != null && keyData!.imagePath.isNotEmpty) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.file(
          File(keyData!.imagePath),
        ),
      );
    } else {
      return Stack(
        children: [
          KeyPositionedLabel(
            position: LabelPosition.topLeft,
            text: keyboardKey.labels.topLeft,
            iconData: iconButons[keyboardKey.name],
          ),
          KeyPositionedLabel(
            position: LabelPosition.topRight,
            text: keyboardKey.labels.topRight,
            iconData: iconButons[keyboardKey.name],
          ),
          KeyPositionedLabel(
            position: LabelPosition.center,
            text: keyboardKey.labels.center,
            iconData: iconButons[keyboardKey.name],
            fontSize: 9,
          ),
          KeyPositionedLabel(
            position: LabelPosition.bottomLeft,
            text: keyboardKey.labels.bottomLeft,
            iconData: iconButons[keyboardKey.name],
          ),
          KeyPositionedLabel(
            position: LabelPosition.bottomRight,
            text: keyboardKey.labels.bottomRight,
            iconData: iconButons[keyboardKey.name],
          ),
        ],
      );
    }
  }
}
