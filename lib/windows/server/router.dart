import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/windows/server/controllers/server_controller.dart';
import 'package:streamkeys/windows/server/controllers/touch_buttons_controller.dart';

class ServerRouter {
  static final _router = Router();

  static void routerHandler() {
    final contoroller = TouchButtonsController();

    _router.get('/device-name', ServerController.getDeviceName);

    _router.get('/buttons', contoroller.getButtons);
    _router.get('/<index>/image', contoroller.getImage);
    _router.get('/<index>/click', contoroller.clickButtonAction);
  }

  static Future<Response> routerCall(Request request) => _router.call(request);
}
