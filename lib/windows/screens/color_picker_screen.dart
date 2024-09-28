import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/providers/color_picker_provider.dart';
import 'package:streamkeys/windows/widgets/color-picker/color_picker_app_bar.dart';
import 'package:streamkeys/windows/widgets/color-picker/color_picker_area_widget.dart';
import 'package:streamkeys/windows/widgets/color-picker/color_picker_controls.dart';

class ColorPickerScreen extends StatelessWidget {
  final Color actionColor;

  const ColorPickerScreen({
    super.key,
    required this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ColorPickerAppBar(),
      body: ChangeNotifierProvider(
        create: (_) => ColorPickerProvider(actionColor),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColorPickerAreaWidget(),
              SizedBox(width: 10),
              Expanded(child: ColorPickerControls()),
            ],
          ),
        ),
      ),
    );
  }
}
