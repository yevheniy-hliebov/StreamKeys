import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/typography.dart';

class KeyFieldLabel extends StatelessWidget {
  final String text;

  const KeyFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.captionStrong,
    );
  }
}
