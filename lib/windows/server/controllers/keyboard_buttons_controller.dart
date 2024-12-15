import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/server/controllers/base_controller.dart';
import 'package:streamkeys/windows/services/keyboard_deck_service.dart';
import 'package:streamkeys/windows/services/obs_websocket_service.dart';

class KeyboardButtonsController extends BaseController {
  final KeyboardDeckService keyboardService = KeyboardDeckService();
  ObsWebSocketService obsWebSocketService;

  KeyboardButtonsController(this.obsWebSocketService);

  Future<Response> clickButtonAction(
    Request request,
    String stringKeyCode,
  ) async {
    try {
      if (kDebugMode) {
        print('clicked');
      }
      int keyCode = int.tryParse(stringKeyCode) ?? -1;

      await keyboardService.init();
      Json? json = await keyboardService.getKeyActionInfoJson(keyCode);

      if (json != null && json['action'] != null) {
        BaseAction action = BaseAction.fromJson(json['action']);
        await action.execute(data: obsWebSocketService);
        return Response.ok('Command successfully runned');
      } else {
        return BaseController.handleError('Error');
      }
    } catch (e) {
      return BaseController.handleError(e);
    }
  }
}
