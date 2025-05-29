import 'package:flutter/material.dart';

class ColorHelper {
  static String getHexString(Color color) {
    String alpha = color.a.toInt().toRadixString(16).padLeft(2, '0');
    String red = color.r.toInt().toRadixString(16).padLeft(2, '0');
    String green = color.g.toInt().toRadixString(16).padLeft(2, '0');
    String blue = color.b.toInt().toRadixString(16).padLeft(2, '0');
    return '$alpha$red$green$blue'.toUpperCase();
  }

  static String getOpacityPercentageString(Color color) {
    double alpha = color.a;
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
    return Color.fromARGB(
      newAlpha,
      color.r.toInt(),
      color.g.toInt(),
      color.b.toInt(),
    );
  }
}