import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant KeyNameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != controller.text) {
      controller.text = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Name'),
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
