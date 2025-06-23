import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorHelper {
  static String getHexString(Color? color) {
    if (color == null) return '';
    return color.toHexString();
  }

  static String getOpacityPercentageString(Color color) {
    final double alpha = color.a;
    return (alpha * 100).round().toString();
  }

  static Color? hexToColor(String? hexString) {
    if (hexString == '' || hexString == null) return null;

    hexString = hexString.toUpperCase().replaceAll('#', '');

    if (hexString.length == 6) {
      hexString = 'FF$hexString';
    }

    return Color(int.parse(hexString, radix: 16));
  }

  static Color setOpacity(Color color, double opacityPercent) {
    opacityPercent = opacityPercent.clamp(0, 100);
    final int newAlpha = ((opacityPercent / 100) * 255).round();
    return Color.fromARGB(
      newAlpha,
      color.r.toInt(),
      color.g.toInt(),
      color.b.toInt(),
    );
  }
}
