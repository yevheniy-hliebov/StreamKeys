import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_category.dart';

class BindingActionCategoryTile extends StatelessWidget {
  final void Function()? onTap;
  final BindingActionCategory category;

  const BindingActionCategoryTile({
    super.key,
    this.onTap,
    required this.category,
  });

  static const size = 18.0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      mouseCursor: SystemMouseCursors.click,
      onTap: onTap,
      tileColor: AppColors.of(context).surface,
      leading: _buildIcon(context),
      minLeadingWidth: size,
      title: Text(category.name),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: category.getIcon(context),
    );
  }
}
