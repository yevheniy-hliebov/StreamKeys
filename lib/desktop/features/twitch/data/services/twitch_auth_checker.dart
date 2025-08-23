import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:streamkeys/desktop/features/twitch/data/models/twitch_user_info.dart';
import 'package:streamkeys/desktop/features/twitch/data/services/twitch_auth_service.dart';
import 'package:streamkeys/service_locator.dart';

class TwitchAuthChecker {
  final TwitchTokenService tokenService;

  final _broadcasterController = StreamController<TwitchUserInfo?>.broadcast();
  final _botController = StreamController<TwitchUserInfo?>.broadcast();

  TwitchUserInfo? _cachedBroadcasterInfo;
  TwitchUserInfo? _cachedBotInfo;

  TwitchAuthChecker(this.tokenService) {
    init();
  }

  Stream<TwitchUserInfo?> get broadcasterInfoStream =>
      _broadcasterController.stream;
  Stream<TwitchUserInfo?> get botInfoStream => _botController.stream;

  TwitchUserInfo? get cachedBroadcasterInfo => _cachedBroadcasterInfo;
  TwitchUserInfo? get cachedBotInfo => _cachedBotInfo;

  Future<void> init() async {
    await refreshAll();

    Timer.periodic(const Duration(seconds: 30), (_) {
      refreshBroadcaster();
    });
  }

  Future<void> refreshBroadcaster() async {
    final broadcaster = await _check(tokenService.getBroadcastToken);
    final bot = await _check(tokenService.getBotToken);

    if (TwitchUserInfo.areSameAccount(broadcaster, bot)) {
      await tokenService.deleteBotToken();
      _botController.add(null);
    }

    _cachedBroadcasterInfo = broadcaster;
    _broadcasterController.add(broadcaster);
  }

  Future<void> refreshBot() async {
    final broadcaster = await _check(tokenService.getBroadcastToken);
    final bot = await _check(tokenService.getBotToken);

    if (TwitchUserInfo.areSameAccount(broadcaster, bot)) {
      await tokenService.deleteBotToken();

      _cachedBotInfo = null;
      _botController.add(null);
    } else {
      _cachedBotInfo = bot;
      _botController.add(bot);
    }
  }

  Future<void> refreshAll() async {
    await refreshBroadcaster();
    await refreshBot();
  }

  Future<TwitchUserInfo?> _check(Future<String?> Function() getToken) async {
    final token = await getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('https://api.twitch.tv/helix/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Client-Id': TwitchAuthService.clientId,
      },
    );

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body)['data'][0];
    return TwitchUserInfo.fromJson(json);
  }

  void dispose() {
    _broadcasterController.close();
    _botController.close();
  }
}
