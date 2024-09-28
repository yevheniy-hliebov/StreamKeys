import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamkeys/windows/providers/color_picker_provider.dart';

class HexInputField extends StatelessWidget {
  final ColorPickerProvider provider;

  const HexInputField({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 16, height: 1),
      controller: provider.hexTextController,
      decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-fA-F]+$')),
        LengthLimitingTextInputFormatter(8),
      ],
      onChanged: provider.changeColorByFormField,
    );
  }
}
