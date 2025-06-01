import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';
import 'package:streamkeys/utils/color_helper.dart';

class KeyboardKeyData {
  final int code;
  String name;
  String imagePath;
  Color? backgroundColor;
  final List<BaseAction> actions;

  KeyboardKeyData({
    required this.code,
    this.name = '',
    this.imagePath = '',
    this.backgroundColor,
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

  factory KeyboardKeyData.fromJson(Json json) {
    return KeyboardKeyData(
      code: json['key_code'],
      name: json['name'] ?? '',
      imagePath: json['image_path'] ?? '',
      backgroundColor: ColorHelper.hexToColor(json['background_color']),
      actions: json['actions'] != null ? (json['actions'] as List<dynamic>)
        .map((actionJson) => BaseAction.fromJson(actionJson))
        .toList() : [],
    );
  }

  Json toJson() {
    return {
      'key_code': code,
      'name': name,
      'image_path': imagePath,
      'background_color': ColorHelper.getHexString(backgroundColor),
      'actions': actions.map((action) => action.toJson()).toList(),
    };
  }
}
