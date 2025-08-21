import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/desktop/server/controllers/twitch_controller.dart';

class TwitchRouter {
  final _router = Router();
  final TwitchController _controller;

  TwitchRouter(this._controller) {
    _router.get('/', (Request request) => _controller.redirect(request, false)); 
    _router.get('/bot', (Request request) => _controller.redirect(request, true));
    _router.get('/save', _controller.saveToken);
  }

  Router get router => _router;
}