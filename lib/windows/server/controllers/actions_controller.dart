import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:streamkeys/windows/models/action.dart';
import 'package:streamkeys/windows/services/action_json_handler.dart';
import 'base_controller.dart';

class ActionsController extends BaseController {
  static Future<Response> getActions(Request request) async {
    try {
      final actions = await ButtonActionJsonHandler.readActions();
      final responseActions =
          ButtonActionJsonHandler.list2JsonResponse(actions);

      return Response.ok(
        jsonEncode(responseActions),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return BaseController.handleError(e);
    }
  }

  static Future<Response> getImage(Request request, String id) async {
    try {
      int actionId = int.tryParse(id) ?? -1;
      final actions = await ButtonActionJsonHandler.readActions();
      ButtonAction action = actions.firstWhere((a) => a.id == actionId);

      if (action.imagePath.isNotEmpty) {
        File imageFile = action.getImageFile();
        if (imageFile.existsSync()) {
          return Response.ok(
            action.getImageBytes(),
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

  static Future<Response> clickButtonAction(Request request, String id) async {
    try {
      int actionId = int.tryParse(id) ?? -1;
      final actions = await ButtonActionJsonHandler.readActions();
      ButtonAction action = actions.firstWhere((a) => a.id == actionId);

      await action.runFile();
      return Response.ok('Command successfully runned');
    } catch (e) {
      return BaseController.handleError(e);
    }
  }
}
