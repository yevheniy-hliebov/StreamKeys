import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/field_label.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/binding_action_tile.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_binding_actions_container.dart';

class KeyBindingActionList extends StatelessWidget {
  final List<BindingAction> actions;
  final void Function(int index)? onDeleteActionPressed;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final void Function(int index, BindingAction updatedAction)? onUpdated;

  const KeyBindingActionList({
    super.key,
    required this.actions,
    this.onDeleteActionPressed,
    this.onReorder,
    this.onUpdated,
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
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: actions.length,
                onReorder: (oldIndex, newIndex) {
                  onReorder?.call(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final action = actions[index];
                  return ReorderableDragStartListener(
                    key: Key('$index-${action.actionLabel}'),
                    index: index,
                    child: KeyBindingActionTile(
                      action: action,
                      onDeletePressed: () {
                        onDeleteActionPressed?.call(index);
                      },
                      onUpdated: (updatedAction) {
                        onUpdated?.call(index, updatedAction);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
