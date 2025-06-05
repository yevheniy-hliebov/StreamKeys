import 'package:http/http.dart' as http;
import 'package:streamkeys/common/models/connection_status.dart';

class TwitchConnectionService {
  Future<ConnectionStatus> checkConnection({
    required String accessToken,
    required String clientId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.twitch.tv/helix/users'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Client-Id': clientId,
        },
      );

      if (response.statusCode == 200) {
        return ConnectionStatus.connected;
      } else {
        return ConnectionStatus.notConnected;
      }
    } catch (_) {
      return ConnectionStatus.notConnected;
    }
  }
}
