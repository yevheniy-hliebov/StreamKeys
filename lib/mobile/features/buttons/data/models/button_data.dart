import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
import 'package:streamkeys/desktop/utils/color_helper.dart';

class ButtonData {
  final String keyCode;
  final String name;
  final Color backgroundColor;
  final String imagePath;

  const ButtonData({
    this.keyCode = '',
    this.name = '',
    this.backgroundColor = Colors.transparent,
    this.imagePath = '',
  });

  factory ButtonData.fromJson(String keyCode, Map<String, dynamic> json) {
    return ButtonData(
      keyCode: keyCode,
      name: json[DeckJsonKeys.keyName] ?? '',
      backgroundColor:
          ColorHelper.hexToColor(json[DeckJsonKeys.keyBackgroundColor]) ??
              Colors.transparent,
      imagePath: json[DeckJsonKeys.keyImagePath] ?? '',
    );
  }
}
