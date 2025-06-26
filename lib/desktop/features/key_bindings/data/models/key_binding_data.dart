import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/utils/color_helper.dart';
import 'package:uuid/uuid.dart';

class KeyBindingData extends Equatable {
  final String id;
  final String name;
  final Color? backgroundColor;
  final String imagePath;
  final List<BindingAction> actions;

  const KeyBindingData({
    this.id = '',
    this.name = '',
    this.backgroundColor,
    this.imagePath = '',
    required this.actions,
  });

  factory KeyBindingData.create({
    String? id,
    String name = '',
    Color? backgroundColor,
    String imagePath = '',
    List<BindingAction>? actions,
  }) {
    return KeyBindingData(
      id: id ?? const Uuid().v4(),
      name: name,
      backgroundColor: backgroundColor,
      imagePath: imagePath,
      actions: actions ?? [],
    );
  }

  KeyBindingData copyWith({
    String? id,
    String? name,
    Color? backgroundColor,
    String? imagePath,
    List<BindingAction>? actions,
  }) {
    return KeyBindingData(
      id: id ?? this.id,
      name: name ?? this.name,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      imagePath: imagePath ?? this.imagePath,
      actions: actions ?? this.actions,
    );
  }

  KeyBindingData clear() {
    return KeyBindingData.create();
  }

  factory KeyBindingData.fromJson(Map<String, dynamic> json) {
    List<BindingAction> actions = [];
    if (json['actions'] != null) {
      actions = (json['actions'] as List<dynamic>)
          .map((actionJson) => BindingAction.fromJson(actionJson))
          .toList();
    }

    return KeyBindingData.create(
      name: json['name'] ?? '',
      backgroundColor: ColorHelper.hexToColor(json['background_color']),
      imagePath: json['image_path'] ?? '',
      actions: actions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'background_color': ColorHelper.getHexString(backgroundColor),
      'image_path': imagePath,
      'actions': actions.map((e) {
       return e.toJson(); 
      }).toList(),
    };
  }

  @override
  List<Object?> get props => [name, backgroundColor, imagePath];
}

typedef KeyBindingMap = Map<String, KeyBindingData>;
typedef KeyBindingPagesMap = Map<String, KeyBindingMap>;
