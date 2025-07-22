import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/typography.dart';

class KeyEditorPlaceholder extends StatelessWidget {
  const KeyEditorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Select a key button', style: AppTypography.subtitle),
    );
  }
}
