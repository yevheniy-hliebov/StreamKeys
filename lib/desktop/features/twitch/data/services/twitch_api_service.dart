import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:streamkeys/desktop/features/twitch/data/models/twitch_announcement_color.dart';
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
    final accessToken = _getAccessToken(isBot);
    final broadcasterId = _getBroadcasterId();
    final senderId = _getUserId(isBot);

    await _post(
      Uri.parse('https://api.twitch.tv/helix/chat/messages'),
      accessToken,
      {
        'broadcaster_id': broadcasterId,
        'sender_id': senderId,
        'message': message,
      },
      'Twitch: Message sent ✅',
    );
  }

  Future<void> sendAnnouncementToChat({
    required String message,
    TwitchAnnouncementColor color = TwitchAnnouncementColor.primary,
    bool isBot = false,
  }) async {
    if (message.length > 500) message = message.substring(0, 500);

    final accessToken = _getAccessToken(isBot);
    final broadcasterId = _getBroadcasterId();
    final moderatorId = _getUserId(isBot, forModerator: true);

    await _post(
      Uri.parse('https://api.twitch.tv/helix/chat/announcements'),
      accessToken,
      {
        'broadcaster_id': broadcasterId,
        'moderator_id': moderatorId,
        'message': message,
        'color': color.name,
      },
      'Twitch: Announcement sent ✅',
    );
  }

  String _getAccessToken(bool isBot) {
    final token = isBot
        ? _authChecker.tokenService.cachedBotToken
        : _authChecker.tokenService.cachedBroadcastToken;
    if (token == null) {
      throw Exception(
        'Twitch: Missing access token (${isBot ? "bot" : "broadcaster"}).',
      );
    }
    return token;
  }

  String _getBroadcasterId() {
    final id = _authChecker.cachedBroadcasterInfo?.userId;
    if (id == null) {
      throw Exception('Twitch: Broadcaster ID not available.');
    }
    return id;
  }

  String _getUserId(bool isBot, {bool forModerator = false}) {
    final id = isBot ? _authChecker.cachedBotInfo?.userId : _getBroadcasterId();
    if (id == null) {
      throw Exception(
        'Twitch: ${forModerator ? "Moderator" : "Sender"} ID not available.',
      );
    }
    return id;
  }

  Future<void> _post(
    Uri url,
    String accessToken,
    Map<String, dynamic> body,
    String successMessage,
  ) async {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Client-Id': TwitchAuthService.clientId,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) print(successMessage);
    } else {
      if (kDebugMode) {
        print('Twitch: API error ${response.statusCode} → ${response.body}');
      }
      throw Exception(
        'Twitch: API returned ${response.statusCode}. Response: ${response.body}',
      );
    }
  }
}
