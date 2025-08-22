import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shelf/shelf.dart';
import 'package:streamkeys/desktop/server/controllers/base_controller.dart';
import 'package:streamkeys/service_locator.dart';

class TwitchController extends BaseController {
  final TwitchTokenService _tokenService;
  final TwitchAuthChecker _authChecker;

  TwitchController(this._tokenService, this._authChecker);

  Future<Response> redirect(Request request, bool isBot) async {
    String html = await rootBundle.loadString(
      'assets/html/twitch_redirect.html',
    );

    html = html.replaceAll('\'boolIsBot\'', isBot ? 'true' : 'false');

    return Response.ok(html, headers: {'content-type': 'text/html'});
  }

  Future<Response> saveToken(Request request) async {
    final token = request.url.queryParameters['access_token'];
    final isBot = request.url.queryParameters['bot'] == 'true';
    if (token != null) {
      if (kDebugMode) {
        print('Twitch Access Token: $token, bot: $isBot');
      }

      if (isBot) {
        await _tokenService.saveBotToken(token);
        _authChecker.refreshBot();
      } else {
        await _tokenService.saveBroadcastToken(token);
        _authChecker.refreshBroadcaster();
      }

      return Response.ok('Token saved');
    }
    return Response(400, body: 'Token not found');
  }
}
