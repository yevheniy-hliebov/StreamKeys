import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';

class ColorPickerControls extends StatelessWidget {
  final ColorPickerController controller;

  const ColorPickerControls({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColorPickerAreaWidget(controller: controller),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
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
