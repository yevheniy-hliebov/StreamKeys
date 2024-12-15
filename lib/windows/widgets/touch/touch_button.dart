import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/action_button.dart';
import 'package:streamkeys/windows/models/touch/action_touch_button_info.dart';

class TouchButton extends StatelessWidget {
  final ActionButtonInfo? info;
  final void Function()? onTap;
  final bool isSelected;

  const TouchButton({
    super.key,
    this.info,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseActionButton(
      size: 55,
      onTap: onTap,
      backgroundColor: info?.backgroundColor,
      isSelected: isSelected,
      child: _buildChild(context),
    );
  }

  Widget? _buildChild(BuildContext context) {
    if (info != null && info!.imagePath.isNotEmpty) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.file(
          File(info!.imagePath),
        ),
      );
    }
    return null;
  }
}
