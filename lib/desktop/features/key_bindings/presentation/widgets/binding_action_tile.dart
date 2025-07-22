import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/buttons/small_icon_button.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_action_config_dialog.dart';

class KeyBindingActionTile extends StatelessWidget {
  final BindingAction action;
  final void Function(BindingAction updatedAction)? onUpdated;
  final void Function()? onDeletePressed;

  const KeyBindingActionTile({
    super.key,
    required this.action,
    this.onUpdated,
    this.onDeletePressed,
  });

  static const size = 18.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () async {
        final result = await KeyActionConfigDialog.showConfigDialog(
          context,
          action,
        );
        if (result != null) {
          onUpdated?.call(result);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: Spacing.xs,
          right: Spacing.xxs,
          top: Spacing.xxs,
          bottom: Spacing.xxs,
        ),
        color: AppColors.of(context).background,
        child: Row(
          children: [
            _buildIcon(context),
            const SizedBox(width: Spacing.xs),
            Expanded(
              child: Text(
                action.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SmallIconButton(onPressed: onDeletePressed, icon: Icons.delete),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return SizedBox(width: size, height: size, child: action.getIcon(context));
  }
}
