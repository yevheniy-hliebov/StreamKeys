import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/features/obs/data/repositories/obs_connection_repository.dart';
import 'package:streamkeys/features/server/controllers/keyboard_deck_controller.dart';

class ServerRouter {
  final ObsConnectionRepository repository;
  late KeyboardDeckController keyboardDeckController;

  final _router = Router();

  ServerRouter(this.repository) {
    keyboardDeckController = KeyboardDeckController(repository);
    routerHandler();
  }

  void routerHandler() {
    _router.get('/keyboard/<index>/click', keyboardDeckController.clickKey);
  }

  Future<Response> routerCall(Request request) => _router.call(request);
}
