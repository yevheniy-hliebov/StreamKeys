import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/android/models/action.dart';
import 'package:streamkeys/android/providers/actions_provider.dart';
import 'package:streamkeys/common/widgets/action_button.dart';

class ActionButton extends StatelessWidget {
  final ButtonAction action;
  final double buttonSize;

  const ActionButton({
    super.key,
    required this.action,
    required this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    final actionProvider = Provider.of<ActionsProvider>(context);

    Widget? child;
    if (action.hasImage && !action.disabled) {
      child = Image.network(
        actionProvider.getImageUrl(action.id),
        fit: BoxFit.cover,
      );
    }

    return IgnorePointer(
      ignoring: action.disabled,
      child: BaseActionButton(
        onTap: () => actionProvider.clickAction(action.id),
        tooltipMessage: action.name,
        size: buttonSize,
        child: child ?? const Icon(Icons.lock),
      ),
    );
  }
}
