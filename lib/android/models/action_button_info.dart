import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
import 'package:streamkeys/windows/utils/color_helper.dart';

class ActionButtonInfo {
  final String name;
  final Color backgroundColor;
  final bool hasImage;
  final bool disabled;

  const ActionButtonInfo({
    required this.name,
    required this.backgroundColor,
    required this.hasImage,
    required this.disabled,
  });

  static ActionButtonInfo fromJson(Json json) {
    return ActionButtonInfo(
      name: json['name'] ?? '',
      backgroundColor: ColorHelper.hexToColor(json['background_color']),
      hasImage: json['has_image'],
      disabled: json['disabled'],
    );
  }
}
