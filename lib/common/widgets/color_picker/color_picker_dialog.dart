import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';
import 'package:streamkeys/core/constants/colors.dart';

class ColorPickerDialog extends StatelessWidget {
  late final ColorPickerController controller;

  ColorPickerDialog({super.key, Color color = Colors.transparent}) {
    controller = ColorPickerController(color);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.of(context).background,
      title: Text('Select a color', style: TextTheme.of(context).bodyLarge),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ColorPickerControls(controller: controller),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Text('Cancel', style: TextTheme.of(context).bodyMedium),
        ),
        FilledButton(
          onPressed: () {
            if (context.mounted) {
              Navigator.of(context).pop(controller.pickerColor);
            }
          },
          child: Text('Select', style: TextTheme.of(context).bodyMedium),
        ),
      ],
    );
  }

  static Future<void> showColorPickerDialog(
    BuildContext context, {
    required Color color,
    void Function(Color selectedColor)? onSelectColor,
  }) async {
    final selectedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return ColorPickerDialog(color: color);
      },
    );

    if (selectedColor != null) {
      onSelectColor?.call(selectedColor);
    }
  }
}
