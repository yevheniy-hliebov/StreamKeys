import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streamkeys/core/storage/secure_storable.dart';

class GenericSecureStorage<T extends SecureStorable> {
  final FlutterSecureStorage _secureStorage;
  final T Function() emptyInstance;
  final T Function(Map<String, String>) fromMap;
  T? _cachedData;

  GenericSecureStorage({
    required FlutterSecureStorage secureStorage,
    required this.emptyInstance,
    required this.fromMap,
  }) : _secureStorage = secureStorage;

  T? get cachedData => _cachedData;

  @visibleForTesting
  set cachedDataForTest(T? data) => _cachedData = data;

  Future<T?> loadConnectionData() async {
    final keys = emptyInstance().mapKeys;

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

    _cachedData = fromMap(map);
    return _cachedData;
  }

  Future<void> updateConnectionData({required T newData}) async {
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
