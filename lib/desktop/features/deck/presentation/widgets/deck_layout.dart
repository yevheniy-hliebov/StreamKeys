import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:streamkeys/common/widgets/cursor_manager.dart';
import 'package:streamkeys/core/constants/colors.dart';

class DeckLayout extends StatelessWidget {
  final Widget leftSide;
  final Widget rightSide;
  final Widget mainTop;
  final Widget mainBottom;

  const DeckLayout({
    super.key,
    required this.leftSide,
    required this.rightSide,
    required this.mainTop,
    required this.mainBottom,
  });

  @override
  Widget build(BuildContext context) {
    return ResizableContainer(
      cascadeNegativeDelta: true,
      direction: Axis.horizontal,
      children: <ResizableChild>[
        ResizableChild(
          child: leftSide,
          size: const ResizableSize.pixels(215, min: 215),
          divider: _buildDivider(context, Axis.horizontal),
        ),
        ResizableChild(
          child: ResizableContainer(
            direction: Axis.vertical,
            children: <ResizableChild>[
              ResizableChild(
                child: mainTop,
                size: const ResizableSize.expand(min: 200),
                divider: _buildDivider(context, Axis.vertical),
              ),
              ResizableChild(
                child: mainBottom,
                size: const ResizableSize.pixels(250, min: 250),
              ),
            ],
          ),
          size: const ResizableSize.expand(min: 400),
          divider: _buildDivider(context, Axis.horizontal),
        ),
        ResizableChild(
          child: rightSide,
          size: const ResizableSize.pixels(250, min: 250),
        ),
      ],
    );
  }

  ResizableDivider _buildDivider(BuildContext context, Axis axis) {
    return ResizableDivider(
      thickness: 4,
      color: AppColors.of(context).outlineVariant,
      onDragStart: () {
        CursorManager.showResizeCursor(context, axis);
      },
      onDragEnd: CursorManager.hideCursor,
    );
  }
}
