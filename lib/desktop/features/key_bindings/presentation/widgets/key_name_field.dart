import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_field_label.dart';

class KeyNameField extends StatefulWidget {
  final String initialValue;
  final void Function(String newValue)? onChanged;

  const KeyNameField({
    super.key,
    this.initialValue = '',
    this.onChanged,
  });

  @override
  State<KeyNameField> createState() => _KeyNameFieldState();
}

class _KeyNameFieldState extends State<KeyNameField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const KeyFieldLabel('Name'),
        TextFormField(
          controller: controller,
          onChanged: widget.onChanged,
          style: AppTypography.body,
          decoration: const InputDecoration(hintText: 'Enter a name'),
        ),
      ],
    );
  }
}
