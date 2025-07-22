import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_actions.dart';

class DeckPageListHeader extends StatelessWidget {
  final VoidCallback? onPressedAdd;
  final VoidCallback? onPressedEdit;
  final VoidCallback? onPressedDelete;

  const DeckPageListHeader({
    super.key,
    this.onPressedEdit,
    this.onPressedAdd,
    this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Spacing.sm,
        top: Spacing.xxs,
        bottom: Spacing.xxs,
        right: Spacing.xxs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: Spacing.xs,
        children: <Widget>[
          const Text('Pages', style: AppTypography.bodyStrong),
          DeckPageListActions(
            onPressedAdd: onPressedAdd,
            onPressedEdit: onPressedEdit,
            onPressedDelete: onPressedDelete,
          ),
        ],
      ),
    );
  }
}
