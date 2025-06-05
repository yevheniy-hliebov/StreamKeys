import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/obs/data/repositories/obs_connection_repository.dart';
import 'package:streamkeys/features/server/controllers/keyboard_deck_controller.dart';
import 'package:streamkeys/features/twitch/bloc/auth/twitch_auth_bloc.dart';

class ServerRouter {
  final ObsConnectionRepository obsConnectionRepository;
  final KeyboardDeckPagesBloc keyboardDeckPagesBloc;
  final TwitchRepository twitchRepository;

  late KeyboardDeckController keyboardDeckController;

  final _router = Router();

  ServerRouter({
    required this.obsConnectionRepository,
    required this.keyboardDeckPagesBloc,
    required this.twitchRepository,
  }) {
    keyboardDeckController = KeyboardDeckController(
      obsConnectionRepository: obsConnectionRepository,
      keyboardDeckPagesBloc: keyboardDeckPagesBloc,
      twitchRepository: twitchRepository,
    );
    routerHandler();
  }

  void routerHandler() {
    _router.get('/keyboard/<index>/click', keyboardDeckController.clickKey);
  }

  Future<Response> routerCall(Request request) => _router.call(request);
}
