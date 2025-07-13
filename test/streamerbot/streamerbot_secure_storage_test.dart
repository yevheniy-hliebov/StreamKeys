import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_connection_data.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_secure_storage.dart';

import '../obs/obs_secure_storage_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late StreamerBotSecureStorage service;

  const testData = StreamerBotConnectionData(
    ip: 'localhost',
    port: '8080',
    password: 'pass',
    autoReconnect: false,
  );

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = StreamerBotSecureStorage(secureStorage: mockStorage);
  });

  group('StreamerBotSecureStorage', () {
    test('loadConnectionData returns null if not all keys are set', () async {
      final keys = testData.mapKeys;

      for (final key in keys) {
        when(mockStorage.read(key: key)).thenAnswer((_) async => null);
      }

      final result = await service.loadConnectionData();

      expect(result, isNull);
    });

    test('loadConnectionData returns valid data and caches it', () async {
      final dataMap = testData.toMap();

      for (final entry in dataMap.entries) {
        when(mockStorage.read(key: entry.key))
            .thenAnswer((_) async => entry.value);
      }

      final result = await service.loadConnectionData();

      expect(result, isNotNull);
      expect(result!.url, testData.url);
      expect(result.password, testData.password);
      expect(result.autoReconnect, testData.autoReconnect);

      expect(service.cachedData, isNotNull);
    });

    test('updateConnectionData writes only changed keys', () async {
      const newData = testData;
      final oldData = StreamerBotConnectionData(
        ip: testData.ip,
        port: testData.port,
        password: 'oldpass',
        autoReconnect: true,
      );
      service.cachedDataForTest = oldData;

      await service.updateConnectionData(newData: newData);

      verify(mockStorage.write(key: 'streamerbot_password', value: newData.password))
          .called(1);
      verifyNever(mockStorage.write(key: 'streamerbot_ip', value: anyNamed('value')));
    });

    test('updateConnectionData sets cachedData', () async {
      await service.updateConnectionData(newData: testData);
      expect(service.cachedData, testData);
    });
  });
}
