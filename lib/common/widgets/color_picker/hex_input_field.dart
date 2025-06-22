import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';

class ColorHexInputField extends StatelessWidget {
  final ColorPickerController controller;
  final EdgeInsetsGeometry? contentPadding;

  const ColorHexInputField({
    super.key,
    required this.controller,
    this.contentPadding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, __) {
        return TextFormField(
          controller: controller.hexTextController,
          decoration: InputDecoration(
            contentPadding: contentPadding,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-fA-F]+$')),
            LengthLimitingTextInputFormatter(8),
          ],
          onChanged: controller.onHexChanged,
        );
      },
    );
  }
}