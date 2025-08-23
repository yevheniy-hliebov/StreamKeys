import 'package:streamkeys/desktop/server/server.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class TwitchAuthService {
  final TwitchTokenService _tokenService;

  TwitchAuthService(this._tokenService);

  static const authorizeUrl = 'https://id.twitch.tv/oauth2/authorize';
  static const baseRedirectUrl = 'http://localhost:${Server.port}/api/twitch';
  static const clientId = '9s8aqg4s08xhjgjr6b6l85f8i7xx38';
  static const List<String> scopes = [
    'user:write:chat',
    'user:bot',
    'channel:bot',
    'channel:manage:broadcast',
  ];

  Future<void> login({bool isBot = false}) async {
    final redirectUri = isBot ? '$baseRedirectUrl/bot' : baseRedirectUrl;

    final scopeString = scopes.join('+');
    final url = Uri.parse(
      '$authorizeUrl?client_id=$clientId'
      '&redirect_uri=$redirectUri'
      '&response_type=token'
      '&scope=$scopeString'
      '&force_verify=true',
    );

    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> logout({bool isBot = false}) async {
    if (isBot) {
      await _tokenService.deleteBotToken();
    } else {
      await _tokenService.deleteBroadcastToken();
    }
  }
}
