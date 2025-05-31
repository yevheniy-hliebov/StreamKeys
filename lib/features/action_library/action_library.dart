import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/features/action_library/data/models/actions/category_actions.dart';
import 'package:streamkeys/features/action_library/widgets/action_tile.dart';

class ActionLibrary extends StatelessWidget {
  const ActionLibrary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SColors.of(context).surface,
      child: Center(
        child: Column(
          children: For.generateWidgets(
            CategoryActions.library.length,
            generator: (categoryIndex) {
              final category = CategoryActions.library[categoryIndex];
              return [
                Material(
                  child: ExpansionTile(
                    title: Text(category.name),
                    initiallyExpanded: false,
                    children: For.generateWidgets(
                      category.actions.length,
                      generator: (actionIndex) {
                        final action = category.actions[actionIndex];
                        return [
                          _showBorderBeforeFirstTile(context, actionIndex),
                          ActionTile(action: action),
                        ];
                      },
                    ),
                  ),
                ),
              ];
            },
          ),
        ),
      ),
    );
  }

  Widget _showBorderBeforeFirstTile(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: SColors.of(context).outlineVariant,
              width: 4,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
