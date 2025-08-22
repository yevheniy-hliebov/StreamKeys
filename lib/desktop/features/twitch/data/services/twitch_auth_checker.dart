import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:streamkeys/desktop/features/twitch/data/models/twitch_user_status.dart';
import 'package:streamkeys/desktop/features/twitch/data/services/twitch_auth_service.dart';
import 'package:streamkeys/service_locator.dart';

class TwitchAuthChecker {
  final TwitchTokenService _tokenService;

  final _broadcasterController = StreamController<TwitchUserStatus>.broadcast();
  final _botController = StreamController<TwitchUserStatus>.broadcast();

  TwitchAuthChecker(this._tokenService) {
    refreshBroadcaster();
    refreshBot();

    Timer.periodic(const Duration(seconds: 30), (_) {
      refreshBroadcaster();
      refreshBot();
    });
  }

  Stream<TwitchUserStatus> get broadcasterStatus =>
      _broadcasterController.stream;
  Stream<TwitchUserStatus> get botStatus => _botController.stream;

  Future<void> refreshBroadcaster() async {
    final broadcasterStatus = await _checkStatus(
      _tokenService.getBroadcastToken,
    );
    final botStatus = await _checkStatus(_tokenService.getBotToken);

    if (broadcasterStatus.connected &&
        botStatus.connected &&
        broadcasterStatus.login == botStatus.login) {
      await _tokenService.deleteBotToken();
      _botController.add(const TwitchUserStatus(connected: false));
    }

    _broadcasterController.add(broadcasterStatus);
  }

  Future<void> refreshBot() async {
    final broadcasterStatus = await _checkStatus(
      _tokenService.getBroadcastToken,
    );
    final botStatus = await _checkStatus(_tokenService.getBotToken);

    if (broadcasterStatus.connected &&
        botStatus.connected &&
        broadcasterStatus.login == botStatus.login) {
      await _tokenService.deleteBotToken();
      _botController.add(const TwitchUserStatus(connected: false));
    } else {
      _botController.add(botStatus);
    }
  }

  Future<TwitchUserStatus> _checkStatus(
    Future<String?> Function() getToken,
  ) async {
    final token = await getToken();
    if (token == null) return const TwitchUserStatus(connected: false);

    final response = await http.get(
      Uri.parse('https://api.twitch.tv/helix/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Client-Id': TwitchAuthService.clientId,
      },
    );

    if (response.statusCode != 200) {
      return const TwitchUserStatus(connected: false);
    }

    final data = jsonDecode(response.body)['data'][0];
    return TwitchUserStatus(
      connected: true,
      login: data['login'],
      displayName: data['display_name'],
      avatarUrl: data['profile_image_url'],
    );
  }

  void dispose() {
    _broadcasterController.close();
    _botController.close();
  }
}
