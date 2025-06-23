import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/image_preview.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button_container.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button_labels.dart';

class KeyButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final bool isSelected;
  final bool isHighlighted;
  final KeyBindingData? keyBindingData;
  final BaseKeyData keyData;

  const KeyButton({
    super.key,
    this.width = 50,
    this.height = 50,
    this.onPressed,
    this.isSelected = false,
    this.isHighlighted = false,
    this.keyBindingData,
    required this.keyData,
  });

  @override
  Widget build(BuildContext context) {
    final message = keyBindingData?.name ?? '';
    final highlightedColor =
        AppColors.of(context).primary.withValues(alpha: 0.2);

    return Tooltip(
      message: message.isNotEmpty ? message : keyData.name,
      child: InkWell(
        onTap: onPressed,
        child: KeyButtonContainer(
          width: width,
          height: height,
          isSelected: isSelected,
          backgroundColor: isHighlighted
              ? highlightedColor
              : keyBindingData?.backgroundColor,
          child: _buildChild(context),
        ),
      ),
    );
  }

  Widget? _buildChild(BuildContext context) {
    if (keyBindingData?.imagePath.isNotEmpty == true) {
      return ImagePreview(imagePath: keyBindingData?.imagePath ?? '');
    }

    if (keyData is KeyboardKeyData) {
      return KeyButtonLabels(
        keyName: keyData.name,
        keyLabels: (keyData as KeyboardKeyData).labels,
      );
    }

    return null;
  }
}
