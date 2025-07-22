import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/binding_action_drop_zone.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/binding_action_tile.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_binding_actions_container.dart';

class KeyBindingActionList extends StatelessWidget {
  final List<BindingAction> actions;
  final void Function(BindingAction)? onActionAdded;
  final void Function(int index, BindingAction updatedAction)? onActionUpdated;
  final void Function(int index)? onDeleteActionPressed;
  final void Function(int oldIndex, int newIndex)? onReorderActons;

  const KeyBindingActionList({
    super.key,
    required this.actions,
    this.onActionAdded,
    this.onActionUpdated,
    this.onDeleteActionPressed,
    this.onReorderActons,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.sm),
      child: Column(
        spacing: Spacing.xs,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const FieldLabel('Actions'),
          Flexible(
            child: KeyBindingActionsContainer(
              child: BindingActionDropZone(
                onActionAdded: onActionAdded,
                child: _buildPlaceholder(
                  child: ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    itemCount: actions.length,
                    onReorder: (oldIndex, newIndex) {
                      onReorderActons?.call(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      final action = actions[index];
                      return ReorderableDragStartListener(
                        key: Key('$index-${action.label}'),
                        index: index,
                        child: KeyBindingActionTile(
                          action: action,
                          onDeletePressed: () {
                            onDeleteActionPressed?.call(index);
                          },
                          onUpdated: (updatedAction) {
                            onActionUpdated?.call(index, updatedAction);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder({required Widget child}) {
    if (actions.isEmpty) {
      return const Center(
        child: Text(
          'Drag an action from right, place it on the button or here',
          style: AppTypography.bodyStrong,
        ),
      );
    }

    return child;
  }
}
