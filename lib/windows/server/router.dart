import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/windows/server/controllers/keyboard_buttons_controller.dart';
import 'package:streamkeys/windows/server/controllers/server_controller.dart';
import 'package:streamkeys/windows/server/controllers/touch_buttons_controller.dart';
import 'package:streamkeys/windows/services/obs_websocket_service.dart';

class ServerRouter {
  static final _router = Router();

  static void routerHandler(ObsWebSocketService obsWebSocketService) {
    final touchButtonsController = TouchButtonsController(obsWebSocketService);
    final keyboardButtonsController =
        KeyboardButtonsController(obsWebSocketService);

    _router.get('/device-name', ServerController.getDeviceName);

    _router.get('/buttons', touchButtonsController.getButtons);
    _router.get('/<index>/image', touchButtonsController.getImage);
    _router.get('/<index>/click', touchButtonsController.clickButtonAction);
    _router.get(
        '/keyboard/<index>/click', keyboardButtonsController.clickButtonAction);
  }

  static Future<Response> routerCall(Request request) => _router.call(request);
}
