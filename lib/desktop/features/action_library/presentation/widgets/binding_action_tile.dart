import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';

class BindingActionTile extends StatelessWidget {
  final double height;
  final Color? tileColor;
  final BindingAction bindingAction;

  const BindingActionTile({
    super.key,
    this.height = 50,
    this.tileColor,
    required this.bindingAction,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: tileColor ?? AppColors.of(context).background,
      minTileHeight: height,
      title: Text(bindingAction.name),
    );
  }
}
