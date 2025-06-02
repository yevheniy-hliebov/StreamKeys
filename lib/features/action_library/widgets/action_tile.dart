import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/hover_state.dart';
import 'package:streamkeys/features/action_library/bloc/drag_status_bloc.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';

class ActionTile extends StatelessWidget {
  final BaseAction action;

  const ActionTile({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<BaseAction>(
      data: action,
      onDragStarted: () {
        context.read<DragStatusBloc>().add(const StartDragEvent());
      },
      onDragEnd: (details) {
        context.read<DragStatusBloc>().add(const EndDragEvent());
      },
      feedback: _buildFeedbackTile(context, action.actionName),
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    return HoverState(
      cursor: SystemMouseCursors.click,
      builder: (isHover) {
        final color = isHover
            ? SColors.of(context).background
            : SColors.of(context).surface;

        return Container(
          width: double.maxFinite,
          color: color,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            action.actionLabel,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
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
