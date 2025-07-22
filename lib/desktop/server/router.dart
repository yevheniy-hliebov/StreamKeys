import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/desktop/server/api_router.dart';

class ServerRouter {
  final _router = Router();

  ServerRouter() {
    _init();
  }

  void _init() {
    _router.mount('/api', ApiRouter().router.call);
  }

  Future<Response> routerCall(Request request) => _router.call(request);
}
