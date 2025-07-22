import 'package:flutter/widgets.dart';
import 'package:streamkeys/common/widgets/helpers/for.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_category.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/binding_action_category_tile.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/dragable_binding_action_tile.dart';

class CategoryExpansionTile extends StatelessWidget {
  final BindingActionCategory category;

  const CategoryExpansionTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final controller = ExpansibleController();

    return Expansible(
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
        if (category.actions.isEmpty) {
          return const SizedBox();
        }
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
                return [DragableBindingActionTile(bindingAction: action)];
              },
            ),
          ),
        );
      },
    );
  }
}
