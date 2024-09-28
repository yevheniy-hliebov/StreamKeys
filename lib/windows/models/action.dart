import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:streamkeys/windows/services/file_execution_service.dart';
import 'package:streamkeys/windows/services/file_picker_service.dart';
import 'package:streamkeys/windows/services/action_json_handler.dart';
import 'package:streamkeys/windows/utils/color_helper.dart';

class ButtonAction {
  final int id;
  String name;
  String imagePath;
  String filePath;
  Color backgroundColor;

  ButtonAction({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.filePath,
    this.backgroundColor = Colors.transparent,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'filePath': filePath,
      'backgroundColor': ColorHelper.getHexString(backgroundColor),
    };
  }

  @override
  String toString() => jsonEncode(toJson());

  static ButtonAction fromJson(dynamic json) {
    return ButtonAction(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      filePath: json['filePath'],
      backgroundColor: ColorHelper.hexToColor(
        json['backgroundColor'] ?? ColorHelper.getHexString(Colors.transparent),
      ),
    );
  }

  static List<ButtonAction> fromList(List<dynamic> list) {
    return list.map((e) {
      return fromJson(e);
    }).toList();
  }

  Uint8List getImageBytes() {
    File imageFile = File(imagePath);
    return imageFile.readAsBytesSync();
  }

  File getImageFile() {
    return File(imagePath);
  }

  Future<void> update() async {
    final actions = await ButtonActionJsonHandler.readActions();
    for (var i = 0; i < actions.length; i++) {
      if (actions[i].id == id) {
        actions[i] = this;
        break;
      }
    }
    await ButtonActionJsonHandler.saveActions(actions);
  }

  Future<void> pickImage() async {
    final path = await FilePickerService.pickImage();
    if (path != null) {
      imagePath = path;
    }
  }

  Future<void> pickFile() async {
    final path = await FilePickerService.pickFile();
    if (path != null) {
      filePath = path;
    }
  }

  Future<void> runFile() async {
    await FileExecutionService.runFile(filePath);
  }

  Future<void> clear() async {
    name = '';
    imagePath = '';
    filePath = '';
    backgroundColor = Colors.transparent;
    await update();
  }
}
