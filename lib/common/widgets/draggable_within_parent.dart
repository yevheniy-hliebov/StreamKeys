import 'package:flutter/material.dart';

class DraggableWithinParent extends StatefulWidget {
  final Widget child;

  const DraggableWithinParent({super.key, required this.child});

  @override
  State<DraggableWithinParent> createState() => _DraggableWithinParentState();
}

class _DraggableWithinParentState extends State<DraggableWithinParent> {
  Offset centerPosition = Offset.zero;
  Size childSize = Size.zero;
  final GlobalKey _childKey = GlobalKey();

  void _updateChildSizeAndRecenter(Size parentSize) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? context = _childKey.currentContext;
      if (context == null) return;

      final RenderBox box = context.findRenderObject() as RenderBox;
      final Size newSize = box.size;

      if (newSize != childSize) {
        setState(() {
          childSize = newSize;
          centerPosition = Offset(parentSize.width / 2, parentSize.height / 2);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final Size parentSize = constraints.biggest;

      _updateChildSizeAndRecenter(parentSize);

      final Offset topLeft = Offset(
        centerPosition.dx - childSize.width / 2,
        centerPosition.dy - childSize.height / 2,
      );

      return Stack(
        children: <Widget>[
          Positioned(
            left: topLeft.dx,
            top: topLeft.dy,
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  final Offset newCenter = centerPosition + details.delta;

                  final double minX = childSize.width / 2;
                  final double maxX = parentSize.width - childSize.width / 2;
                  final double minY = childSize.height / 2;
                  final double maxY = parentSize.height - childSize.height / 2;

                  centerPosition = Offset(
                    newCenter.dx.clamp(
                        minX - childSize.width / 2, maxX + childSize.width / 2),
                    newCenter.dy.clamp(minY - childSize.height / 2,
                        maxY + childSize.height / 2),
                  );
                });
              },
              child: KeyedSubtree(
                key: _childKey,
                child: widget.child,
              ),
            ),
          ),
        ],
      );
    });
  }
}
