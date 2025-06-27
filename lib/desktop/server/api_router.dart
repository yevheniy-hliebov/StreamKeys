import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ApiRouter {
  final _router = Router();

  ApiRouter() {
    _router.get('/', (Request request) => Response.ok('API Worked!'));
  }

  Router get router => _router;
}
