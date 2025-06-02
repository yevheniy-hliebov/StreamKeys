import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';

class KeyColorPicker extends StatelessWidget {
  final ColorPickerController controller;

  const KeyColorPicker({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Background Color',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 35,
              child: ColorHexInputField(controller: controller),
            ),
            const SizedBox(width: 8),
            ColorIndicator(
              width: 35,
              height: 35,
              controller: controller,
              withButton: true,
            ),
          ],
        ),
      ],
    );
  }
}
