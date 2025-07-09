import 'package:flutter/material.dart';

class CheckboxTile extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool value)? onChanged;

  const CheckboxTile({
    super.key,
    required this.label,
    this.value = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: (value) {
            if (value == null) return;
            onChanged?.call(value);
          },
        ),
        Text(label),
      ],
    );
  }
}
