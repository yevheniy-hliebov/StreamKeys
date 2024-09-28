import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/providers/color_picker_provider.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () {
            if (context.mounted) {
              final pickerColor = Provider.of<ColorPickerProvider>(context, listen: false).pickerColor;
              Navigator.of(context).pop(pickerColor);
            }
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}
