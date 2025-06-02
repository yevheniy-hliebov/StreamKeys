import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/hover_state.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';

class KeyActionTile extends StatelessWidget {
  final BaseAction action;
  final int index;
  final VoidCallback onTap;
  final void Function()? onDelete;

  const KeyActionTile({
    super.key,
    required this.action,
    required this.index,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ReorderableDragStartListener(
        index: index,
        child: HoverState(builder: (isHover) {
          return ListTile(
            title: Text(
              action.actionName,
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            tileColor: SColors.of(context).background,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            minTileHeight: 0,
            onTap: onTap,
            trailing: isHover
                ? Transform.scale(
                    scale: 0.8,
                    child: IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete),
                    ),
                  )
                : null,
          );
        }),
      ),
    );
  }
}
