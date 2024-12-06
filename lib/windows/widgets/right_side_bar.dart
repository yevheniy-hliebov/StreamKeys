import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/models/category_actions.dart';

class RightSideBar extends StatelessWidget {
  const RightSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final actionCategories = CategoryActions.categories;
    return Container(
      width: double.maxFinite,
      constraints: const BoxConstraints(
        maxWidth: 235,
      ),
      color: SColors.of(context).surface,
      child: Column(
        children: actionCategories.map(
          (category) {
            return ExpansionTile(
              title: Text(category.name),
              children: [
                for (int i = 0; i < category.actions.length; i++) ...[
                  Draggable<BaseAction>(
                    data: category.actions[i],
                    feedback: _buildFeedbackTile(
                        context, category.actions[i].actionType),
                    child: ListTile(
                      tileColor: SColors.of(context).surface,
                      shape: i == 0
                          ? Border(
                              top: BorderSide(
                                color: SColors.of(context).outlineVariant,
                                width: 4,
                              ),
                            )
                          : null,
                      title: Text(category.actions[i].actionType),
                    ),
                  ),
                ],
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildFeedbackTile(BuildContext context, String text) {
    return Container(
      color: SColors.of(context).surface,
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: SColors.of(context).onSurface,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
