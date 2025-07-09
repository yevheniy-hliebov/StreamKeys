import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/helpers/for.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_category.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/binding_action_category_tile.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/dragable_binding_action_tile.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_devider.dart';

class ActionLibrary extends StatelessWidget {
  const ActionLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    final library = BindingActionCategory.library;
    final controller = ExpansibleController();

    return Column(
      children: For.fromList<BindingActionCategory>(
        items: library,
        generator: (category) {
          return [
            Expansible(
              controller: controller,
              headerBuilder: (context, animation) {
                return BindingActionCategoryTile(
                  category: category,
                  onTap: () {
                    if (controller.isExpanded) {
                      controller.collapse();
                    } else {
                      controller.expand();
                    }
                  },
                );
              },
              bodyBuilder: (context, animation) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.of(context).background,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.of(context).outlineVariant,
                        width: 4,
                      ),
                    ),
                  ),
                  child: Column(
                    children: For.fromList<BindingAction>(
                      items: category.actions,
                      generator: (action) {
                        return [
                          DragableBindingActionTile(bindingAction: action),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
            const DeckDevider(axis: Axis.horizontal),
          ];
        },
      ),
    );
  }
}
