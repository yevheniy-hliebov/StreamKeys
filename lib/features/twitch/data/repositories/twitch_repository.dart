import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streamkeys/features/twitch/data/models/twich_account.dart';
import 'package:http/http.dart' as http;

class TwitchRepository {
  final _storage = const FlutterSecureStorage();

  TwitchAccount? broadcasterAccount;
  TwitchAccount? botAccount;

  Future<void> saveAccount(TwitchAccount account, String prefix) async {
    if (prefix == 'broadcaster') {
      broadcasterAccount = account;
    } else {
      botAccount = account;
    }

    account.userId = await getUserIdFromUsername(account);
    final data = account.toMap(prefix);
    for (final entry in data.entries) {
      await _storage.write(key: entry.key, value: entry.value);
    }
  }

  Future<TwitchAccount?> loadAccount(String prefix) async {
    final keys = [
      'username',
      'accessToken',
      'refreshToken',
      'clientId',
      'userId'
    ];
    final data = <String, String>{};

    for (final key in keys) {
      final value = await _storage.read(key: '${prefix}_$key');
      if (value == null) return null;
      data['${prefix}_$key'] = value;
    }

    final account = TwitchAccount.fromMap(data, prefix);

    if (prefix == 'broadcaster') {
      broadcasterAccount = account;
    } else {
      botAccount = account;
    }

    return account;
  }

  Future<String> getUserIdFromUsername(TwitchAccount account) async {
    if (account.username.isEmpty &&
        account.accessToken.isEmpty &&
        account.clientId.isEmpty) {
      return '';
    }

    final url = Uri.parse(
        'https://api.twitch.tv/helix/users?login=${account.username}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${account.accessToken}',
        'Client-Id': account.clientId,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final users = data['data'] as List<dynamic>;
      if (users.isNotEmpty) {
        return users.first['id'] as String;
      } else {
        throw Exception('User not found');
      }
    } else {
      throw Exception(
          'Failed to fetch user ID: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> sendChatMessage({
    required String broadcasterId,
    required TwitchAccount senderAccount,
    required String message,
  }) async {
    if (senderAccount.userId.isEmpty &&
        senderAccount.accessToken.isEmpty &&
        senderAccount.clientId.isEmpty) {
      return;
    }

    final url = Uri.parse('https://api.twitch.tv/helix/chat/messages');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${senderAccount.accessToken}',
        'Client-Id': senderAccount.clientId,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'broadcaster_id': broadcasterId,
        'sender_id': senderAccount.userId,
        'message': message,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Failed to send message: ${response.statusCode} ${response.body}');
    }
  }
}
