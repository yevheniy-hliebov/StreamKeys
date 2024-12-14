import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/common/widgets/action_button.dart';
import 'package:streamkeys/windows/models/keyboard_action_button_info.dart';
import 'package:streamkeys/windows/models/keyboard_key.dart';

class KeyboardButton extends StatelessWidget {
  final KeyboardKey keyboardKey;
  final KeyboardActionButtonInfo? info;
  final void Function()? onTap;
  final bool isSelected;
  final double size;

  const KeyboardButton({
    super.key,
    required this.keyboardKey,
    this.info,
    this.isSelected = false,
    this.onTap,
    this.size = 55,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: keyboardKey.name.toUpperCase(),
      child: BaseActionButton(
        size: size,
        onTap: onTap,
        backgroundColor: info?.backgroundColor,
        isSelected: isSelected,
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (info == null || !info!.isHaveAction) {
      return Stack(
        children: [
          Positioned(
            top: 7,
            left: 7,
            child: _buildLabel(
              context,
              keyboardKey.labels.topLeft,
            ),
          ),
          Positioned(
            top: 7,
            right: 7,
            child: _buildLabel(
              context,
              keyboardKey.labels.topRight,
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: _buildLabel(
              context,
              keyboardKey.labels.center,
              fontSize: 9,
            ),
          ),
          Positioned(
            bottom: 7,
            left: 7,
            child: _buildLabel(
              context,
              keyboardKey.labels.bottomLeft,
            ),
          ),
          Positioned(
            bottom: 7,
            right: 7,
            child: _buildLabel(
              context,
              keyboardKey.labels.bottomRight,
            ),
          ),
        ],
      );
    }

    if (info!.imagePath.isEmpty) {
      return Icon(
        Icons.edit,
        color: SColors.of(context).onBackground,
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.file(
          File(info!.imagePath),
        ),
      );
    }
  }

  Text _buildLabel(
    BuildContext context,
    String label, {
    double fontSize = 12,
  }) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: fontSize,
        color: SColors.of(context).onBackground,
      ),
    );
  }
}
