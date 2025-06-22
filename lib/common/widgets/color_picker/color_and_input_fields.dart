import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';

class ColorAndInputFields extends StatelessWidget {
  final ColorPickerController controller;

  const ColorAndInputFields({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        ColorIndicator(controller: controller),
        Expanded(
          child: SizedBox(
            width: double.maxFinite,
            height: 30,
            child: ColorHexInputField(controller: controller),
          ),
        ),
        SizedBox(
          width: 61,
          height: 30,
          child: OpacityInputField(controller: controller),
        ),
      ],
    );
  }
}