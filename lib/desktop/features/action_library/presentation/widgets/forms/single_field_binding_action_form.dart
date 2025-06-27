import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/field_label.dart';

class SingleFieldBindingActionForm extends StatefulWidget {
  final String label;
  final String initialValue;
  final void Function(String newValue)? onUpdate;

  const SingleFieldBindingActionForm({
    super.key,
    required this.label,
    required this.initialValue,
    this.onUpdate,
  });

  @override
  State<SingleFieldBindingActionForm> createState() => _SingleFieldBindingActionFormState();
}

class _SingleFieldBindingActionFormState extends State<SingleFieldBindingActionForm> {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(widget.label),
        TextFormField(
          controller: controller,
          onChanged: widget.onUpdate,
        ),
      ],
    );
  }
}
