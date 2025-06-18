import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/draggable_within_parent.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/grid/grid_area.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_area_wrapper.dart';

class KeyGridArea extends StatelessWidget {
  final DeckType deckType;

  const KeyGridArea({
    super.key,
    required this.deckType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.of(context).background,
      alignment: Alignment.center,
      child: DraggableWithinParent(
        child: Container(
          padding: const EdgeInsets.all(Spacing.md),
          margin: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: AppColors.of(context).surface,
            borderRadius: BorderRadius.circular(Spacing.xs),
            border: Border.all(
              width: 1,
              color: AppColors.of(context).outline,
            ),
          ),
          child: deckType.isGrid
              ? const GridArea()
              : const KeyboardAreaWrapper(),
        ),
      ),
    );
  }
}
