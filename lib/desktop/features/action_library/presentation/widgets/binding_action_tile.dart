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

  static const size = 18.0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      mouseCursor: SystemMouseCursors.click,
      tileColor: tileColor ?? AppColors.of(context).background,
      minTileHeight: height,
      leading: _buildIcon(context),
      minLeadingWidth : size,
      title: Text(bindingAction.name),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: bindingAction.getIcon(context),
    );
  }
}
