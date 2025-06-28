import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/server/controllers/grid_deck_controller.dart';
import 'package:streamkeys/desktop/server/controllers/key_controller.dart';

class ApiRouter {
  final _router = Router();
  final _keyController = KeyController();
  final _gridDeckController = GridDeckController();

  ApiRouter() {
    _router.get('/', (Request request) => Response.ok('API Worked!'));
    
    _router.get('/grid/buttons', _gridDeckController.getButtons);
    _router.get('/grid/<index>/image', _gridDeckController.getImage);
    _router.get('/grid/<index>/click', (Request request, String keyCode) {
      return _keyController.clickKey(request, keyCode, DeckType.grid);
    });

    _router.get('/keyboard/<index>/click', (Request request, String keyCode) {
      return _keyController.clickKey(request, keyCode, DeckType.keyboard);
    });
  }

  Router get router => _router;
}
