import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/server/controllers/grid_deck_controller.dart';
import 'package:streamkeys/desktop/server/controllers/key_controller.dart';
import 'package:streamkeys/desktop/server/controllers/twitch_controller.dart';
import 'package:streamkeys/desktop/server/routers/twitch_router.dart';
import 'package:streamkeys/service_locator.dart';

class ApiRouter {
  final _router = Router();
  final _keyController = KeyController();
  final _gridDeckController = GridDeckController();
  final _twitchController = TwitchController(
    sl<TwitchTokenService>(),
    sl<TwitchAuthChecker>(),
  );

  ApiRouter() {
    _router.get('/', (Request request) => Response.ok('API Worked!'));

    _router.mount('/twitch', TwitchRouter(_twitchController).router.call);

    _router.get('/grid/buttons', _gridDeckController.getButtons);
    _router.get('/grid/<index>/image', _gridDeckController.getImage);
    _router.post('/grid/<index>', (Request request, String keyCode) {
      return _keyController.clickKey(request, keyCode, DeckType.grid);
    });

    _router.post('/keyboard/<index>', (Request request, String keyCode) {
      return _keyController.clickKey(request, keyCode, DeckType.keyboard);
    });
  }

  Router get router => _router;
}
