import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';

class ColorPickerAreaWidget extends StatelessWidget {
  final ColorPickerController controller;
  final double width;
  final double height;

  const ColorPickerAreaWidget({
    super.key,
    required this.controller,
    this.width = 100,
    this.height = 136,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            width: width,
            height: height,
            child: ColorPickerArea(
              controller.hsvColor,
              controller.onColorChanged,
              PaletteType.hsv,
            ),
          ),
        );
      },
    );
  }
}