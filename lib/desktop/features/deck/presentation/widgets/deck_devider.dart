import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';

class DeckDevider extends StatelessWidget {
  final Axis axis;

  const DeckDevider({super.key, required this.axis});

  @override
  Widget build(BuildContext context) {
    const double thickness = 4;
    final Color color = AppColors.of(context).outlineVariant;

    if (axis == Axis.vertical) {
      return VerticalDivider(
        width: thickness,
        thickness: thickness,
        color: color,
      );
    } else {
      return Divider(height: thickness, thickness: thickness, color: color);
    }
  }
}
