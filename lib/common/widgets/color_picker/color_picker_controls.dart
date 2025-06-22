import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';
import 'package:streamkeys/core/constants/spacing.dart';

class ColorPickerControls extends StatelessWidget {
  final ColorPickerController controller;

  const ColorPickerControls({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Spacing.md,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColorPickerAreaWidget(controller: controller),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: Spacing.md,
            children: [
              ColorSliders(controller: controller),
              ColorAndInputFields(controller: controller),
            ],
          ),
        ),
      ],
    );
  }
}