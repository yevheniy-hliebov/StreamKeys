import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streamkeys/desktop/features/obs/data/models/obs_connection_data.dart';

class ObsSecureStorage {
  final FlutterSecureStorage _secureStorage;
  ObsConnectionData? _cachedData;

  ObsSecureStorage({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  ObsConnectionData? get cachedData => _cachedData;

  @visibleForTesting
  set cachedDataForTest(ObsConnectionData? data) => _cachedData = data;

  @visibleForTesting
  ObsConnectionData? get cachedDataForTest => _cachedData;

  Future<ObsConnectionData?> loadConnectionData() async {
    final keys = const ObsConnectionData(
      ip: '',
      port: '',
      password: '',
      autoReconnect: false,
    ).toMap().keys;

    final entries = await Future.wait(
      keys.map(
          (key) async => MapEntry(key, await _secureStorage.read(key: key))),
    );

    final map = Map<String, String>.fromEntries(
      entries
          .where((e) => e.value != null)
          .map((e) => MapEntry(e.key, e.value!)),
    );

    if (map.length != keys.length) return null;

    _cachedData = ObsConnectionData.fromMap(map);
    return _cachedData;
  }

  Future<void> updateConnectionData({
    required ObsConnectionData newData,
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
