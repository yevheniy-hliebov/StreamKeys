import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/windows/server/controllers/actions_controller.dart';
import 'package:streamkeys/windows/server/controllers/server_controller.dart';

class ServerRouter {
  static final _router = Router();

  static void routerHandler() {
    _router.get('/device-name', ServerController.getDeviceName);

    _router.get('/actions', ActionsController.getActions);
    _router.get('/<id>/image', ActionsController.getImage);
    _router.get('/<id>/click', ActionsController.clickButtonAction);
  }

  static Future<Response> routerCall(Request request) => _router.call(request);
}
