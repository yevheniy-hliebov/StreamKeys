import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/services/file_picker_service.dart';
import 'package:streamkeys/windows/utils/color_helper.dart';

class ActionButtonInfo {
  String name;
  String imagePath;
  Color backgroundColor;
  List<BaseAction> actions;

  ActionButtonInfo({
    this.name = '',
    this.imagePath = '',
    this.backgroundColor = Colors.transparent,
    List<BaseAction>? actions,
  }) : actions = actions ?? [];

  void onClick() {
    for (var action in actions) {
      action.execute();
    }
  }

  Future<void> pickImage() async {
    final path = await FilePickerService.pickImage();
    if (path != null) {
      imagePath = path;
    }
  }

  bool get hasActions => actions.isNotEmpty;

  Json toJson() {
    return {
      'name': name,
      'image_path': imagePath,
      'background_color': ColorHelper.getHexString(backgroundColor),
      'actions': actions.map((action) => action.toJson()).toList(),
    };
  }

  ActionButtonInfo copy() {
    return ActionButtonInfo(
      name: name,
      actions: List<BaseAction>.from(actions),
      backgroundColor: backgroundColor,
      imagePath: imagePath,
    );
  }

  void clear() {
    name = '';
    imagePath = '';
    backgroundColor = Colors.transparent;
    actions.clear();
  }

  void delete() {
    clear();
  }

  factory ActionButtonInfo.fromJson(Json json) {
    final backgroundColor = json['background_color'] != null
        ? ColorHelper.hexToColor(json['background_color'])
        : Colors.transparent;

    List<BaseAction> singleAction =
        json['action'] != null ? [BaseAction.fromJson(json['action'])] : [];

    List<BaseAction> actionList = json['actions'] != null
        ? (json['actions'] as List<dynamic>)
            .map((e) => BaseAction.fromJson(e))
            .toList()
        : singleAction;

    return ActionButtonInfo(
      name: json['name'],
      imagePath: json['image_path'],
      backgroundColor: backgroundColor,
      actions: actionList,
    );
  }
}
