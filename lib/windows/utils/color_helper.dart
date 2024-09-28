import 'package:flutter/material.dart';

class ColorHelper {
  static String getHexString(Color color) {
    return color.value.toRadixString(16).toUpperCase();
  }

  static String getOpacityPercentageString(Color color) {
    int alpha = color.alpha;
    return ((alpha / 255) * 100).round().toString();
  }

  static Color hexToColor(String hexString) {
    hexString = hexString.toUpperCase().replaceAll('#', '');

    if (hexString.length == 6) {
      hexString = 'FF$hexString';
    }

    return Color(int.parse(hexString, radix: 16));
  }

  static Color setOpacity(Color color, double opacityPercent) {
    opacityPercent = opacityPercent.clamp(0, 100);

    int newAlpha = ((opacityPercent / 100) * 255).round();

    return Color.fromARGB(newAlpha, color.red, color.green, color.blue);
  }
}
