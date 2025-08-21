import 'package:http/http.dart' as http;
import 'package:streamkeys/desktop/features/twitch/data/services/twitch_auth_service.dart';
import 'package:streamkeys/service_locator.dart';

class TwitchAuthChecker {
  final TwitchTokenService _tokenService;

  TwitchAuthChecker(this._tokenService);

  Future<bool> _checkTokenValid(String token) async {
    final response = await http.get(
      Uri.parse('https://api.twitch.tv/helix/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Client-Id': TwitchAuthService.clientId,
      },
    );
    return response.statusCode == 200;
  }

  Stream<bool> broadcasterStatus({
    Duration interval = const Duration(seconds: 30),
  }) {
    return Stream.periodic(interval).asyncMap((_) async {
      final token = await _tokenService.getBroadcastToken();
      if (token == null) return false;
      return await _checkTokenValid(token);
    });
  }

  Stream<bool> botStatus({Duration interval = const Duration(seconds: 30)}) {
    return Stream.periodic(interval).asyncMap((_) async {
      final token = await _tokenService.getBotToken();
      if (token == null) return false;
      return await _checkTokenValid(token);
    });
  }
}
