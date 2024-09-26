import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const RefreshButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
    );
  }
}
