import 'package:flutter/material.dart';
import 'package:streamkeys/windows/utils/color_helper.dart';

class ButtonAction {
  final int id;
  final String name;
  final Color backgroundColor;
  final bool hasImage;
  final bool disabled;

  const ButtonAction({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.hasImage,
    required this.disabled,
  });

  static ButtonAction fromJson(Map<String, dynamic> json) {
    return ButtonAction(
      id: json['id'],
      name: json['name'],
      backgroundColor: ColorHelper.hexToColor(json['backgroundColor']),
      hasImage: json['hasImage'],
      disabled: json['disabled'],
    );
  }

  static List<ButtonAction> fromArrayJson(List<dynamic> list) {
    return list.map(
      (action) {
        return fromJson(action);
      },
    ).toList();
  }
}
