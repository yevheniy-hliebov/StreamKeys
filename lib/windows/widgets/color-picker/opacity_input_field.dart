import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamkeys/windows/providers/color_picker_provider.dart';

class OpacityInputField extends StatelessWidget {
  final ColorPickerProvider provider;

  const OpacityInputField({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 16, height: 1),
      controller: provider.opacityPercentController,
      onChanged: provider.changeOpacityByFormField,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(8),
        suffixText: '%',
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-fA-F]+$')),
        LengthLimitingTextInputFormatter(8),
      ],
    );
  }
}
