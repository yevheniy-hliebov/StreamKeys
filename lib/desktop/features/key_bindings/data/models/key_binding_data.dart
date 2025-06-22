import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/utils/color_helper.dart';

class KeyBindingData extends Equatable {
  final String name;
  final Color? backgroundColor;
  final String imagePath;

  const KeyBindingData({
    this.name = '',
    this.backgroundColor,
    this.imagePath = '',
  });

  KeyBindingData copyWith({
    String? name,
    Color? backgroundColor,
    String? imagePath,
  }) {
    return KeyBindingData(
      name: name ?? this.name,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      imagePath: imagePath ?? this.imagePath,
    );
  }

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

  @override
  List<Object?> get props => [name, backgroundColor, imagePath];
}

typedef KeyBindingMap = Map<String, KeyBindingData>;
typedef KeyBindingPagesMap = Map<String, KeyBindingMap>;
