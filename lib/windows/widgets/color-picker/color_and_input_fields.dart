import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/providers/color_picker_provider.dart';
import 'package:streamkeys/windows/widgets/color-picker/hex_input_field.dart';
import 'package:streamkeys/windows/widgets/color-picker/opacity_input_field.dart';

class ColorAndInputFields extends StatelessWidget {
  final ColorPickerProvider provider;

  const ColorAndInputFields({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: provider.pickerColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: SColors.of(context).outline,
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 132,
          height: 30,
          child: HexInputField(provider: provider),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 61,
          height: 30,
          child: OpacityInputField(provider: provider),
        ),
      ],
    );
  }
}
