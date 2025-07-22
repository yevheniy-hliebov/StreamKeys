import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/cursor_status/bloc/cursor_status_bloc.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/binding_action_tile.dart';
import 'package:streamkeys/desktop/utils/helper_functions.dart';

class DragableBindingActionTile extends StatelessWidget {
  final BindingAction bindingAction;

  const DragableBindingActionTile({super.key, required this.bindingAction});

  @override
  Widget build(BuildContext context) {
    final child = BindingActionTile(bindingAction: bindingAction);

    return Draggable<BindingAction>(
      data: bindingAction,
      onDragStarted: () {
        context.read<CursorStatusBloc>().add(CursorForbidden());
      },
      onDragEnd: (_) {
        context.read<CursorStatusBloc>().add(CursorDefault());
      },
      dragAnchorStrategy: HelperFunctions.dragAnchorBottomLeftStrategy,
      feedback: Material(
        type: MaterialType.transparency,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(8),
          child: Container(
            width: 200,
            height: 50,
            color: AppColors.of(context).background,
            alignment: Alignment.center,
            child: Material(
              child: BindingActionTile(
                bindingAction: bindingAction,
                height: 50,
                tileColor: AppColors.of(context).primary.withValues(alpha: 0.1),
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.5, child: child),
      child: child,
    );
  }
}
