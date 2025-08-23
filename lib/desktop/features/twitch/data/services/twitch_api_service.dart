import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:streamkeys/desktop/features/twitch/data/services/twitch_auth_checker.dart';
import 'package:http/http.dart' as http;
import 'package:streamkeys/desktop/features/twitch/data/services/twitch_auth_service.dart';

class TwitchApiService {
  final TwitchAuthChecker _authChecker;

  const TwitchApiService(this._authChecker);

  Future<void> sendMessage({
    required String message,
    bool isBot = false,
  }) async {
    final url = Uri.parse('https://api.twitch.tv/helix/chat/messages');

    final accessToken = isBot
        ? _authChecker.tokenService.cachedBotToken
        : _authChecker.tokenService.cachedBroadcastToken;

    if (accessToken == null) {
      throw Exception(
        'Twitch: Failed to send message → missing access token '
        '(${isBot ? "bot" : "broadcaster"}).',
      );
    }

    final broadcasterId = _authChecker.cachedBroadcasterInfo?.userId;
    if (broadcasterId == null) {
      throw Exception(
        'Twitch: Failed to send message → broadcaster_id is null. '
        'Broadcaster data not cached/loaded.',
      );
    }

    final senderId = isBot
        ? _authChecker.cachedBotInfo?.userId
        : broadcasterId;

    if (senderId == null) {
      throw Exception(
        'Twitch: Failed to send message → sender_id is null. '
        'Sender user data not available.',
      );
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Client-Id': TwitchAuthService.clientId,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'broadcaster_id': broadcasterId,
        'sender_id': senderId,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Twitch: Message sent ✅');
      }
    } else {
      if (kDebugMode) {
        print('Twitch: API error ${response.statusCode} → ${response.body}');
      }
      throw Exception(
        'Twitch: Failed to send message → API returned ${response.statusCode}. '
        'Response: ${response.body}',
      );
    }
  }
}
