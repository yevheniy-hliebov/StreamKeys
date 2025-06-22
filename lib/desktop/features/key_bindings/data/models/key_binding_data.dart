import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/utils/color_helper.dart';
import 'package:uuid/uuid.dart';

class KeyBindingData extends Equatable {
  final String id;
  final String name;
  final Color? backgroundColor;
  final String imagePath;

  const KeyBindingData({
    this.id = '',
    this.name = '',
    this.backgroundColor,
    this.imagePath = '',
  });

  factory KeyBindingData.create({
    String? id,
    String name = '',
    Color? backgroundColor,
    String imagePath = '',
  }) {
    return KeyBindingData(
      id: id ?? const Uuid().v4(),
      name: name,
      backgroundColor: backgroundColor,
      imagePath: imagePath,
    );
  }

  KeyBindingData copyWith({
    String? id,
    String? name,
    Color? backgroundColor,
    String? imagePath,
  }) {
    return KeyBindingData(
      id: id ?? this.id,
      name: name ?? this.name,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  KeyBindingData clear() {
    return KeyBindingData.create();
  }

  factory KeyBindingData.fromJson(Map<String, dynamic> json) {
    return KeyBindingData.create(
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
