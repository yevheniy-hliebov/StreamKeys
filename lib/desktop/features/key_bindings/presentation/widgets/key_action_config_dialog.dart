import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';

class KeyActionConfigDialog extends StatelessWidget {
  final BindingAction action;

  const KeyActionConfigDialog({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    BindingAction localAction = action;

    return AlertDialog(
      backgroundColor: AppColors.of(context).background,
      title: Text(action.dialogTitle),
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxWidth: 350),
        child: action.form(
          context,
          onUpdated: (updatedAction) {
            localAction = updatedAction;
          },
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(localAction);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  static Future<BindingAction?> showConfigDialog(
    BuildContext context,
    BindingAction action,
  ) async {
    return showDialog<BindingAction>(
      context: context,
      builder: (context) => KeyActionConfigDialog(action: action),
    );
  }
}
