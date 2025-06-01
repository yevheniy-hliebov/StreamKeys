import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/base_key_button.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/key_positioned_label.dart';

class KeyboardButton extends StatelessWidget {
  final KeyboardKey keyboardKey;
  final void Function()? onTap;
  final bool isSelected;
  final bool isDragHighlighted;
  final double size;

  const KeyboardButton({
    super.key,
    required this.keyboardKey,
    this.isSelected = false,
    this.isDragHighlighted = false,
    this.onTap,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return BaseKeyButton(
      size: size,
      tooltipMessage: keyboardKey.name.toUpperCase(),
      onTap: onTap,
      backgroundColor: SColors.of(context).background,
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
    // if (info != null && info!.imagePath.isNotEmpty) {
    //   return SizedBox(
    //     width: double.infinity,
    //     height: double.infinity,
    //     child: Image.file(
    //       File(info!.imagePath),
    //     ),
    //   );
    // } else {
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
    // }
  }
}
