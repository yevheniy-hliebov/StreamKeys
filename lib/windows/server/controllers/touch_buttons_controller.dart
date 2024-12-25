import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/server/controllers/base_controller.dart';
import 'package:streamkeys/windows/services/obs_websocket_service.dart';
import 'package:streamkeys/windows/services/touch_deck_service.dart';

class TouchButtonsController extends BaseController {
  final touchDeckService = TouchDeckService();
  ObsWebSocketService obsWebSocketService;

  TouchButtonsController(this.obsWebSocketService);

  Future<Response> getButtons(Request request) async {
    try {
      Json json = await touchDeckService.getData();
      String currentPage = json['current_page'];
      List<dynamic> currentPageButtons = json['map_pages'][currentPage];

      Json jsonResponse = {
        'grid': json['selected_grid'],
        'current_page': json['current_page'],
        'buttons': currentPageButtons.map(
          (buttonJson) {
            return {
              'name': buttonJson['name'],
              'background_color': buttonJson['background_color'],
              'has_image': buttonJson['image_path'] != '',
            };
          },
        ).toList(),
      };

      return Response.ok(
        jsonEncode(jsonResponse),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return BaseController.handleError(e);
    }
  }

  Future<Response> getImage(Request request, String stringIndex) async {
    try {
      int index = int.tryParse(stringIndex) ?? -1;

      Json json = await touchDeckService.getData();
      String currentPage = json['current_page'];
      Json buttonInfo = json['map_pages'][currentPage][index];

      if (buttonInfo['image_path'].isNotEmpty) {
        File imageFile = File(buttonInfo['image_path']);
        if (imageFile.existsSync()) {
          return Response.ok(
            imageFile.readAsBytesSync(),
            headers: {'Content-Type': 'image/jpeg'},
          );
        } else {
          return Response.notFound('Image not found');
        }
      } else {
        return Response.notFound('Image not found');
      }
    } catch (e) {
      return BaseController.handleError(e);
    }
  }

  Future<Response> clickButtonAction(
    Request request,
    String stringIndex,
  ) async {
    try {
      int index = int.tryParse(stringIndex) ?? -1;

      Json json = await touchDeckService.getData();
      String currentPage = json['current_page'];
      Json buttonInfo = json['map_pages'][currentPage][index];
      final actionsJson = buttonInfo['actions'] as List;

      List<BaseAction> actions = actionsJson.map((actionJson) {
        return BaseAction.fromJson(actionJson);
      }).toList();

      for (var action in actions) {
        if (kDebugMode) {
          print(action.actionType);
        }
        await action.execute(data: obsWebSocketService);
      }
      return Response.ok('Actions successfully runned');
    } catch (e) {
      return BaseController.handleError(e);
    }
  }
}
