import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button_labels.dart';

class KeyButton extends StatelessWidget {
  final BaseKeyData keyData;
  final double size;

  const KeyButton({
    super.key,
    required this.keyData,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: keyData.name,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.of(context).background,
          border: Border.all(
            color: AppColors.of(context).outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: _buildChild(context),
      ),
    );
  }

  Widget? _buildChild(BuildContext context) {
    if (keyData is KeyboardKeyData) {
      return KeyButtonLabels(
        keyName: keyData.name,
        keyLabels: (keyData as KeyboardKeyData).labels,
      );
    }
    return null;
  }
}
