import 'package:flutter/material.dart';

class SquareIconButton extends StatelessWidget {
  final double size;
  final VoidCallback? onPressed;
  final IconData icon;

  const SquareIconButton({
    super.key,
    this.size = 40,
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
        ),
        onPressed: onPressed,
        child: Icon(icon, size: 16),
      ),
    );
  }
}
