import 'package:flutter/material.dart';

class DeckPagesActionButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;

  const DeckPagesActionButton({
    super.key,
    required this.iconData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(iconData),
      iconSize: 18,
    );
  }
}
