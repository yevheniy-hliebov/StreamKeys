import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TwitchTokenService {
  final FlutterSecureStorage _storage;

  TwitchTokenService(this._storage);

  static const _botTokenKey = 'twitch_bot_access_token';
  static const _broadcastTokenKey = 'twitch_broadcast_access_token';

  String? _cachedBotToken;
  String? _cachedBroadcastToken;

  String? get cachedBotToken => _cachedBotToken;
  String? get cachedBroadcastToken => _cachedBroadcastToken;

  Future<void> saveBotToken(String token) async {
    _cachedBotToken = token;
    await _storage.write(key: _botTokenKey, value: token);
  }

  Future<void> saveBroadcastToken(String token) async {
    _cachedBroadcastToken = token;
    await _storage.write(key: _broadcastTokenKey, value: token);
  }

  Future<String?> getBotToken() async {
    if (_cachedBotToken != null) return _cachedBotToken;
    _cachedBotToken = await _storage.read(key: _botTokenKey);
    return _cachedBotToken;
  }

  Future<String?> getBroadcastToken() async {
    if (_cachedBroadcastToken != null) return _cachedBroadcastToken;
    _cachedBroadcastToken = await _storage.read(key: _broadcastTokenKey);
    return _cachedBroadcastToken;
  }

  Future<void> deleteBotToken() async {
    _cachedBotToken = null;
    await _storage.delete(key: _botTokenKey);
  }

  Future<void> deleteBroadcastToken() async {
    _cachedBroadcastToken = null;
    await _storage.delete(key: _broadcastTokenKey);
  }

  Future<bool> hasBotToken() async => (await getBotToken()) != null;
  Future<bool> hasBroadcastToken() async => (await getBroadcastToken()) != null;
}
