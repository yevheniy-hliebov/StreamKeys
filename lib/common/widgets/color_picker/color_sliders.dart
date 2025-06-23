import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';
import 'package:streamkeys/core/constants/spacing.dart';

class ColorSliders extends StatelessWidget {
  final ColorPickerController controller;

  const ColorSliders({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            spacing: Spacing.xs,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 40,
                child: ColorPickerSlider(
                  TrackType.hue,
                  controller.hsvColor,
                  controller.onColorChanged,
                  displayThumbColor: true,
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                height: 40,
                child: ColorPickerSlider(
                  TrackType.alpha,
                  controller.hsvColor,
                  controller.onColorChanged,
                  displayThumbColor: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
