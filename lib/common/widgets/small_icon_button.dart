import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/spacing.dart';

class SmallIconButton extends StatelessWidget {
  final String? tooltip;
  final VoidCallback? onPressed;
  final IconData icon;

  const SmallIconButton({
    super.key,
    this.tooltip,
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 16,
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(Spacing.xs),
      tooltip: tooltip,
    );
  }
}
