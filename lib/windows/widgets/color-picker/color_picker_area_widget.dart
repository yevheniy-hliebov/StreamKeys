import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/providers/color_picker_provider.dart';

class ColorPickerAreaWidget extends StatelessWidget {
  const ColorPickerAreaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ColorPickerProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        width: 100,
        height: 189,
        child: ColorPickerArea(
          provider.hsvColor,
          provider.changeColor,
          PaletteType.hsv,
        ),
      ),
    );
  }
}
