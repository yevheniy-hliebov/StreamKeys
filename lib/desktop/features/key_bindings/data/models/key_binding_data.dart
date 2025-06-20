import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/utils/color_helper.dart';

class KeyBindingData {
  String name;
  Color? backgroundColor;
  String imagePath;

  KeyBindingData({
    this.name = '',
    this.backgroundColor,
    this.imagePath = '',
  });

  factory KeyBindingData.fromJson(Map<String, dynamic> json) {
    return KeyBindingData(
      name: json['name'] ?? '',
      backgroundColor: ColorHelper.hexToColor(json['background_color']),
      imagePath: json['image_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'background_color': ColorHelper.getHexString(backgroundColor),
      'image_path': imagePath,
    };
  }
}

typedef KeyBindingMap = Map<String, KeyBindingData>;
typedef KeyBindingPagesMap = Map<String, KeyBindingMap>;
