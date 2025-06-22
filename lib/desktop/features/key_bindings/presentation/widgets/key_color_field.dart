import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_field_label.dart';

class KeyColorField extends StatefulWidget {
  final Color? initialValue;
  final void Function(Color newValue)? onChanged;

  const KeyColorField({
    super.key,
    this.initialValue = Colors.transparent,
    this.onChanged,
  });

  @override
  State<KeyColorField> createState() => _KeyColorFieldState();
}

class _KeyColorFieldState extends State<KeyColorField> {
  late ColorPickerController controller;

  @override
  void initState() {
    super.initState();

    controller = ColorPickerController(widget.initialValue ?? Colors.transparent);

    controller.addListener(() {
      widget.onChanged?.call(controller.pickerColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    const double height = 32;

    return Column(
      spacing: Spacing.xs,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const KeyFieldLabel('Background Color'),
        Row(
          spacing: Spacing.xs,
          children: [
            SizedBox(
              width: 100,
              height: height,
              child: ColorHexInputField(controller: controller),
            ),
            ColorIndicator(
              width: height,
              height: height,
              controller: controller,
              withButtonToOpenPickerDialog: true,
            ),
          ],
        ),
      ],
    );
  }
}
