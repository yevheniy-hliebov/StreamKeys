import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';
import 'package:streamkeys/utils/color_helper.dart';

class KeyboardKeyData {
  final String id;
  int code;
  String name;
  String imagePath;
  Color? backgroundColor;
  final List<BaseAction> actions;

  KeyboardKeyData({
    String? id,
    required this.code,
    this.name = '',
    this.imagePath = '',
    this.backgroundColor,
    required this.actions,
  }) : id = id ?? const Uuid().v4(); // генерується автоматично

  KeyboardKeyData copy() {
    return KeyboardKeyData(
      id: id,
      code: code,
      name: name,
      imagePath: imagePath,
      backgroundColor: backgroundColor,
      actions: actions,
    );
  }

  factory KeyboardKeyData.fromJson(Json json) {
    return KeyboardKeyData(
      id: json['id'],
      code: json['key_code'],
      name: json['name'] ?? '',
      imagePath: json['image_path'] ?? '',
      backgroundColor: ColorHelper.hexToColor(json['background_color']),
      actions: json['actions'] != null
          ? (json['actions'] as List<dynamic>)
              .map((actionJson) => BaseAction.fromJson(actionJson))
              .toList()
          : [],
    );
  }

  Json toJson() {
    return {
      'id': id,
      'key_code': code,
      'name': name,
      'image_path': imagePath,
      'background_color': ColorHelper.getHexString(backgroundColor),
      'actions': actions.map((action) => action.toJson()).toList(),
    };
  }
}
