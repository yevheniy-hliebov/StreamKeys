import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button_labels.dart';

class KeyButton extends StatelessWidget {
  final double size;
  final VoidCallback? onPressed;
  final bool isSelected;
  final KeyBindingData? keyBindingData;
  final BaseKeyData keyData;

  const KeyButton({
    super.key,
    this.size = 50,
    this.onPressed,
    this.isSelected = false,
    this.keyBindingData,
    required this.keyData,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: keyBindingData?.name ?? keyData.name,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: keyBindingData?.backgroundColor ??
                AppColors.of(context).background,
            border: Border.all(
              color: isSelected
                  ? AppColors.of(context).primary
                  : AppColors.of(context).outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.5),
            child: _buildChild(context),
          ),
        ),
      ),
    );
  }

  Widget? _buildChild(BuildContext context) {
    if (keyBindingData?.imagePath.isNotEmpty == true) {
      return Image.file(
        File(keyBindingData!.imagePath),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
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
