import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/providers/color_picker_provider.dart';
import 'package:streamkeys/windows/widgets/color-picker/color_picker_area_widget.dart';
import 'package:streamkeys/windows/widgets/color-picker/color_picker_controls.dart';

class ColorPickerDialog extends StatelessWidget {
  final Color actionColor;

  const ColorPickerDialog({
    super.key,
    required this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ColorPickerProvider(actionColor),
      child: const Dialog(
        child: IntrinsicWidth(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select a color',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ColorPickerAreaWidget(),
                    SizedBox(width: 16),
                    ColorPickerControls(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showColorPickerDialog(
  BuildContext context, {
  required Color prevColor,
  void Function(Color selectedColor)? onSelectColor,
}) async {
  final selectedColor = await showDialog<Color>(
    context: context,
    builder: (BuildContext context) {
      return ColorPickerDialog(actionColor: prevColor);
    },
  );

  if (selectedColor != null) {
    onSelectColor?.call(selectedColor);
  }
}
