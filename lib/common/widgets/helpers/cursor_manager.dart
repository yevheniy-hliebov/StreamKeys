import 'package:flutter/material.dart';

class CursorManager {
  static OverlayEntry? _cursorOverlay;

  static void showResizeCursor(BuildContext context, Axis axis) {
    if (_cursorOverlay != null) return;

    _cursorOverlay = OverlayEntry(
      builder: (_) => MouseRegion(
        cursor: axis == Axis.horizontal
            ? SystemMouseCursors.resizeColumn
            : SystemMouseCursors.resizeRow,
        child: Container(),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_cursorOverlay!);
  }

  static void hideCursor() {
    _cursorOverlay?.remove();
    _cursorOverlay = null;
  }
}
