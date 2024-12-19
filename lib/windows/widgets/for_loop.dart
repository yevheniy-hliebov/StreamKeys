import 'package:flutter/material.dart';

class For {
  static List<Widget> generateWidgets(
    int count, {
    required List<Widget> Function(int index) generator,
  }) {
    List<Widget> widgetList = [];
    for (var i = 0; i < count; i++) {
      widgetList.addAll(generator(i));
    }
    return widgetList;
  }
}
