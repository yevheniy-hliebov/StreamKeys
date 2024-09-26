import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:streamkeys/windows/services/file_execution_service.dart';
import 'package:streamkeys/windows/services/file_picker_service.dart';
import 'package:streamkeys/windows/services/action_json_handler.dart';

class ButtonAction {
  final int id;
  String name;
  String imagePath;
  String filePath;

  ButtonAction({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'filePath': filePath,
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
    await update();
  }
}
