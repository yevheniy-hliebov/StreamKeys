import 'package:flutter/material.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';

class KeyboardKeyData {
  final int code;
  String name;
  String imagePath;
  Color backgroundColor;
  final List<BaseAction> actions;

  KeyboardKeyData({
    required this.code,
    this.name = '',
    this.imagePath = '',
    this.backgroundColor = Colors.transparent,
    required this.actions,
  });

  KeyboardKeyData copy() {
    return KeyboardKeyData(
      code: code,
      name: name,
      imagePath: imagePath,
      backgroundColor: backgroundColor,
      actions: actions,
    );
  }
}
