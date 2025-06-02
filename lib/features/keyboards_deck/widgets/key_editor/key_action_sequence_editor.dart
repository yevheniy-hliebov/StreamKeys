import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/key_editor/key_action_config_dialog.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/key_editor/key_action_tile.dart';

class KeyActionSequenceEditor extends StatelessWidget {
  final List<BaseAction> actions;
  final void Function()? onActionsChanged;

  const KeyActionSequenceEditor({
    super.key,
    required this.actions,
    this.onActionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const _ActionsPlaceholder();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        const _ActionsHeader(),
        Flexible(
          child: _ActionsContainer(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: actions.length,
              onReorder: _reorder,
              itemBuilder: (context, index) {
                final action = actions[index];
                return KeyActionTile(
                  key: ValueKey('$index-${action.actionName}'),
                  action: action,
                  index: index,
                  onTap: () => _showConfigDialog(context, action),
                  onDelete: () => _delete(index),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final item = actions.removeAt(oldIndex);
    actions.insert(newIndex, item);
    onActionsChanged?.call();
  }

  void _delete(int index) {
    actions.removeAt(index);
    onActionsChanged?.call();
  }

  void _showConfigDialog(BuildContext context, BaseAction action) {
    showDialog(
      context: context,
      builder: (context) => KeyActionConfigDialog(
        action: action,
        onSaved: onActionsChanged,
      ),
    );
  }
}

class _ActionsPlaceholder extends StatelessWidget {
  const _ActionsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Drag an action from right, place it on the button or here',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ActionsHeader extends StatelessWidget {
  const _ActionsHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Actions',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }
}

class _ActionsContainer extends StatelessWidget {
  final Widget child;

  const _ActionsContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = SColors.of(context);
    final borderRadius = BorderRadius.circular(8);

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(width: 1, color: colors.onSurface),
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.hardEdge,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
