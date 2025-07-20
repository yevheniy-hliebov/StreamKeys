import 'package:flutter/material.dart';

typedef OnCheckUpdate = Future<void> Function();

class VersionStatusMenu extends StatelessWidget {
  final Widget child;
  final OnCheckUpdate onCheckUpdate;

  const VersionStatusMenu({
    required this.child,
    required this.onCheckUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) async {
        final renderBox = context.findRenderObject() as RenderBox;
        final overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;

        final position = RelativeRect.fromRect(
          Rect.fromPoints(
            renderBox.localToGlobal(details.localPosition, ancestor: overlay),
            renderBox.localToGlobal(details.localPosition, ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );

        final selection = await showMenu<String>(
          context: context,
          position: position,
          items: const [
            PopupMenuItem(value: 'check', child: Text('Check For Update')),
          ],
        );

        if (selection == 'check') {
          await onCheckUpdate();
        }
      },
      child: child,
    );
  }
}
