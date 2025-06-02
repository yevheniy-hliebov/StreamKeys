import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/obs/data/repositories/obs_connection_repository.dart';
import 'package:streamkeys/features/server/controllers/keyboard_deck_controller.dart';

class ServerRouter {
  final ObsConnectionRepository obsConnectionRepository;
  final KeyboardDeckPagesBloc keyboardDeckPagesBloc;
  late KeyboardDeckController keyboardDeckController;

  final _router = Router();

  ServerRouter({
    required this.obsConnectionRepository,
    required this.keyboardDeckPagesBloc,
  }) {
    keyboardDeckController = KeyboardDeckController(
      obsConnectionRepository: obsConnectionRepository,
      keyboardDeckPagesBloc: keyboardDeckPagesBloc,
    );
    routerHandler();
  }

  void routerHandler() {
    _router.get('/keyboard/<index>/click', keyboardDeckController.clickKey);
  }

  Future<Response> routerCall(Request request) => _router.call(request);
}
