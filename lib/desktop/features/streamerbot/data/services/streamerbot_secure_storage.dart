import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_connection_data.dart';

class StreamerBotSecureStorage {
  final FlutterSecureStorage _secureStorage;
  StreamerBotConnectionData? _cachedData;

  StreamerBotSecureStorage({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  StreamerBotConnectionData? get cachedData => _cachedData;

  @visibleForTesting
  set cachedDataForTest(StreamerBotConnectionData? data) => _cachedData = data;

  Future<StreamerBotConnectionData?> loadConnectionData() async {
    final keys = const StreamerBotConnectionData().mapKeys;

    final entries = await Future.wait(
      keys.map((key) async {
        return MapEntry(key, await _secureStorage.read(key: key));
      }),
    );

    final map = Map<String, String>.fromEntries(
      entries
          .where((e) => e.value != null)
          .map((e) => MapEntry(e.key, e.value!)),
    );

    if (map.length != keys.length) return null;

    _cachedData = StreamerBotConnectionData.fromMap(map);
    return _cachedData;
  }

  Future<void> updateConnectionData({
    required StreamerBotConnectionData newData,
  }) async {
    final newMap = newData.toMap();
    final oldMap = _cachedData?.toMap() ?? {};

    for (final entry in newMap.entries) {
      if (oldMap[entry.key] != entry.value) {
        await _secureStorage.write(key: entry.key, value: entry.value);
      }
    }

    _cachedData = newData;
  }
}
