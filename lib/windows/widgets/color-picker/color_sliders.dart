import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/providers/color_picker_provider.dart';

class ColorSliders extends StatelessWidget {
  const ColorSliders({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ColorPickerProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 243,
            height: 40,
            child: ColorPickerSlider(
              TrackType.hue,
              provider.hsvColor,
              provider.changeColor,
              displayThumbColor: true,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 243,
            height: 40,
            child: ColorPickerSlider(
              TrackType.alpha,
              provider.hsvColor,
              provider.changeColor,
              displayThumbColor: true,
            ),
          ),
        ],
      ),
    );
  }
}
