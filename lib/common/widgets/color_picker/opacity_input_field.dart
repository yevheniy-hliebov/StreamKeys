import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';

class OpacityInputField extends StatelessWidget {
  final ColorPickerController controller;

  const OpacityInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, __) {
        return TextField(
          controller: controller.opacityPercentController,
          onChanged: controller.onOpacityChanged,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(8),
            suffixText: '%',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _OpacityRangeFormatter(),
          ],
        );
      },
    );
  }
}

class _OpacityRangeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '0',
        selection: TextSelection.collapsed(
          offset: 1,
        ),
      );
    }

    if (int.parse(oldValue.text) == 0 && int.parse(newValue.text) != 0) {
      final newOpacity = int.parse(newValue.text);
      return TextEditingValue(
        text: newOpacity.toString(),
        selection: TextSelection.collapsed(
          offset: newOpacity.toString().length,
        ),
      );
    }

    if (int.parse(newValue.text) > 100) {
      return oldValue;
    }

    return newValue;
  }
}