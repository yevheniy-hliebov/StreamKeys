import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';

enum LabelPosition { topLeft, topRight, bottomLeft, bottomRight, center }

class KeyPositionedLabel extends StatelessWidget {
  final String text;
  final IconData? iconData;
  final double horizontalPadding;
  final double verticalPadding;
  final LabelPosition position;
  final double fontSize;

  const KeyPositionedLabel({
    super.key,
    required this.text,
    this.iconData,
    this.horizontalPadding = 7,
    this.verticalPadding = 7,
    required this.position,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (iconData != null && text.isNotEmpty) {
      content = Icon(iconData, size: fontSize + 10);
    } else {
      content = _buildLabel(context, text, fontSize: fontSize);
    }

    switch (position) {
      case LabelPosition.topLeft:
        return Positioned(
          top: verticalPadding,
          left: horizontalPadding,
          child: content,
        );
      case LabelPosition.topRight:
        return Positioned(
          top: verticalPadding,
          right: horizontalPadding,
          child: content,
        );
      case LabelPosition.bottomLeft:
        return Positioned(
          bottom: verticalPadding,
          left: horizontalPadding,
          child: content,
        );
      case LabelPosition.bottomRight:
        return Positioned(
          bottom: verticalPadding,
          right: horizontalPadding,
          child: content,
        );
      case LabelPosition.center:
        return Align(alignment: Alignment.center, child: content);
    }
  }

  Text _buildLabel(BuildContext context, String label, {double fontSize = 12}) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: fontSize,
        color: AppColors.of(context).onBackground,
      ),
    );
  }
}
