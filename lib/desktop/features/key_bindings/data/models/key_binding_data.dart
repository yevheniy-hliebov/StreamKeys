import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
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
    if (json[DeckJsonKeys.keyActions] != null) {
      actions = (json[DeckJsonKeys.keyActions] as List<dynamic>)
          .map((actionJson) => BindingAction.fromJson(actionJson))
          .toList();
    }

    return KeyBindingData.create(
      name: json[DeckJsonKeys.keyName] ?? '',
      backgroundColor: ColorHelper.hexToColor(
        json[DeckJsonKeys.keyBackgroundColor],
      ),
      imagePath: json[DeckJsonKeys.keyImagePath] ?? '',
      actions: actions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DeckJsonKeys.keyName: name,
      DeckJsonKeys.keyBackgroundColor: ColorHelper.getHexString(
        backgroundColor,
      ),
      DeckJsonKeys.keyImagePath: imagePath,
      DeckJsonKeys.keyActions: actions.map((e) {
        return e.toJson();
      }).toList(),
    };
  }

  @override
  List<Object?> get props => [id, name, backgroundColor, imagePath, actions];
}

typedef KeyBindingMap = Map<String, KeyBindingData>;
typedef KeyBindingPagesMap = Map<String, KeyBindingMap>;
