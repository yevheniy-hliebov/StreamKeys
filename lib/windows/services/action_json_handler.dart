import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/action.dart';
import 'package:streamkeys/windows/utils/color_helper.dart';
import 'package:streamkeys/windows/utils/json_read_and_write.dart';

class ButtonActionJsonHandler {
  static const JsonReadAndWrite jsonReadAndWrite =
      JsonReadAndWrite(fileName: 'actions.json');
  static const int actionsCount = 28;

  ButtonActionJsonHandler();

  static List<ButtonAction> generateList() {
    List<ButtonAction> actions = List.generate(actionsCount, (index) {
      return ButtonAction(
        id: index,
        name: '',
        backgroundColor: Colors.transparent,
        imagePath: '',
        filePath: '',
      );
    });

    return actions;
  }

  static List<ButtonAction> fromList(List<dynamic> list) {
    return list.map((action) {
      return ButtonAction.fromJson(action);
    }).toList();
  }

  static Future<List<ButtonAction>> readActions() async {
    final content = await jsonReadAndWrite.read();
    if (content == '') {
      List<ButtonAction> actions = generateList();
      await jsonReadAndWrite.save(jsonEncode(actions));
      return actions;
    } else {
      return fromList(jsonDecode(content));
    }
  }

  static Future<void> saveActions(List<ButtonAction> actions) async {
    await jsonReadAndWrite.save(jsonEncode(actions));
  }

  static List<Map<String, dynamic>> list2JsonResponse(List<ButtonAction> list) {
    return list.map(
      (action) {
        return {
          'id': action.id,
          'name': action.name,
          'backgroundColor': ColorHelper.getHexString(action.backgroundColor),
          'hasImage': action.imagePath != '',
          'disabled': action.filePath == '',
        };
      },
    ).toList();
  }
}
