import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/cursor_status/bloc/cursor_status_bloc.dart';
import 'package:streamkeys/desktop/utils/helper_function.dart';

class KeyDragWrapper extends StatelessWidget {
  final int keyCode;
  final double width;
  final double height;
  final void Function(int firstCode, int secondCode)? onSwapBindingData;
  final Widget Function(bool isHighlighted, double? feedbackButtonsSize)
      childBuilder;

  const KeyDragWrapper({
    super.key,
    required this.keyCode,
    this.width = 50,
    this.height = 50,
    this.onSwapBindingData,
    required this.childBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        onSwapBindingData?.call(details.data, keyCode);
      },
      onWillAcceptWithDetails: (details) {
        final isHighlighted = details.data != keyCode;
        context.read<CursorStatusBloc>().add(CursorDrag());
        return isHighlighted;
      },
      onLeave: (_) {
        context.read<CursorStatusBloc>().add(CursorForbidden());
      },
      builder: (context, candidateKeyData, __) {
        final isHighlighted = candidateKeyData.isNotEmpty;

        final widgetChild = LongPressDraggable<int>(
          data: keyCode,
          dragAnchorStrategy: HelperFunctions.dragAnchorStrategy,
          feedback: Material(
            type: MaterialType.transparency,
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: childBuilder(isHighlighted, min(width, height)),
            ),
          ),
          onDragStarted: () {
            context.read<CursorStatusBloc>().add(CursorDrag());
          },
          onDragEnd: (_) {
            context.read<CursorStatusBloc>().add(CursorDefault());
          },
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: childBuilder(isHighlighted, null),
          ),
          child: childBuilder(isHighlighted, null),
        );

        return widgetChild;
      },
    );
  }
}
