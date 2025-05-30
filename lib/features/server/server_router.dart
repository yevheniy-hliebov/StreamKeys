import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/features/server/controllers/keyboard_deck_controller.dart';

class ServerRouter {
  final _router = Router();
  final keyboardDeckController = KeyboardDeckController();

  ServerRouter() {
    routerHandler();
  }

  void routerHandler() {
    _router.get('/keyboard/<index>/click', keyboardDeckController.clickKey);
  }

  Future<Response> routerCall(Request request) => _router.call(request);
}
