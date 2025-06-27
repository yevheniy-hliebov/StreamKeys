import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';

class BindingActionDropZone extends StatelessWidget {
  final void Function(BindingAction action)? onActionAdded;
  final Widget child;

  const BindingActionDropZone({
    super.key,
    required this.child,
    this.onActionAdded,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<BindingAction>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        onActionAdded?.call(details.data.copy());
      },
      builder: (context, candidateData, _) {
        final isHighlighted = candidateData.isNotEmpty;
        return Stack(
          children: [
            child,
            if (isHighlighted)
              Positioned.fill(
                child: ColoredBox(
                  color: AppColors.of(context).primary.withValues(alpha: 0.2),
                ),
              ),
          ],
        );
      },
    );
  }
}
