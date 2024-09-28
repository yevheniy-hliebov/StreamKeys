import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/providers/color_picker_provider.dart';
import 'package:streamkeys/windows/widgets/color-picker/action_buttons.dart';
import 'package:streamkeys/windows/widgets/color-picker/color_and_input_fields.dart';
import 'package:streamkeys/windows/widgets/color-picker/color_sliders.dart';

class ColorPickerControls extends StatelessWidget {
  const ColorPickerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ColorPickerProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const ColorSliders(),
        const SizedBox(height: 10),
        ColorAndInputFields(provider: provider),
        const Spacer(),
        const ActionButtons(),
      ],
    );
  }
}
