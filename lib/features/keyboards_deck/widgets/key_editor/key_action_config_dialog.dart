import 'package:flutter/material.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';

class KeyActionConfigDialog extends StatelessWidget {
  final BaseAction action;
  final VoidCallback? onSaved;

  const KeyActionConfigDialog({
    super.key,
    required this.action,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(action.dialogTitle),
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: action.formFields(context),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            action.cancel();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            action.save();
            onSaved?.call();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
