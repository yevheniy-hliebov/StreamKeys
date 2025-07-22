import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';

class KeyBindingActionsContainer extends StatefulWidget {
  final Widget child;

  const KeyBindingActionsContainer({super.key, required this.child});

  @override
  State<KeyBindingActionsContainer> createState() =>
      _KeyBindingActionsContainerState();
}

class _KeyBindingActionsContainerState
    extends State<KeyBindingActionsContainer> {
  late final OverlayEntry _entry;

  @override
  void initState() {
    super.initState();
    _entry = OverlayEntry(builder: (context) => widget.child);
  }

  @override
  void didUpdateWidget(covariant KeyBindingActionsContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _entry.markNeedsBuild();
  }

  @override
  void dispose() {
    _entry.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
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
        child: Overlay(initialEntries: [_entry]),
      ),
    );
  }
}
