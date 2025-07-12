import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streamkeys/desktop/features/obs/data/models/obs_connection_data.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_secure_storage.dart';

import 'obs_secure_storage_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late MockFlutterSecureStorage mockStorage;
  late ObsSecureStorage secureStorage;

  const validData = ObsConnectionData(
    ip: '192.168.1.1',
    port: '4455',
    password: 'pass',
    autoReconnect: true,
  );

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    secureStorage = ObsSecureStorage(secureStorage: mockStorage);
  });

  group('loadConnectionData', () {
    test('returns null if any key is missing', () async {
      when(mockStorage.read(key: 'obs_ip'))
          .thenAnswer((_) async => 'testValue');
      when(mockStorage.read(key: 'obs_port'))
          .thenAnswer((_) async => 'testValue');
      when(mockStorage.read(key: 'obs_password')).thenAnswer((_) async => null);
      when(mockStorage.read(key: 'obs_auto_reconnect'))
          .thenAnswer((_) async => 'false');

      final result = await secureStorage.loadConnectionData();

      expect(result, isNull);
      expect(secureStorage.cachedData, isNull);
    });

    test('loads full data and caches it', () async {
      final map = validData.toMap();

      when(mockStorage.read(key: anyNamed('key'))).thenAnswer(
          (invocation) async =>
              map[invocation.namedArguments[const Symbol('key')] as String]);

      final result = await secureStorage.loadConnectionData();

      expect(result, isNotNull);
      expect(result!.ip, validData.ip);
      expect(result.port, validData.port);
      expect(result.password, validData.password);
      expect(result.autoReconnect, validData.autoReconnect);

      expect(secureStorage.cachedData, isNotNull);
    });
  });

  group('updateConnectionData', () {
    test('writes only changed keys', () async {
      const oldData = validData;
      const newData = ObsConnectionData(
        ip: '192.168.1.1',
        port: '4456',
        password: 'pass',
        autoReconnect: false,
      );

      secureStorage = ObsSecureStorage(secureStorage: mockStorage);
      secureStorage.cachedDataForTest = oldData;

      when(mockStorage.write(
        key: anyNamed('key'),
        value: anyNamed('value'),
      )).thenAnswer((_) async {});

      await secureStorage.updateConnectionData(newData: newData);

      verify(mockStorage.write(key: 'obs_port', value: '4456')).called(1);
      verify(mockStorage.write(key: 'obs_auto_reconnect', value: 'false'))
          .called(1);

      verifyNever(mockStorage.write(key: 'obs_ip', value: anyNamed('value')));
      verifyNever(
          mockStorage.write(key: 'obs_password', value: anyNamed('value')));

      expect(secureStorage.cachedData, newData);
    });

    test('writes all keys if no cached data', () async {
      secureStorage = ObsSecureStorage(secureStorage: mockStorage);

      when(mockStorage.write(
        key: anyNamed('key'),
        value: anyNamed('value'),
      )).thenAnswer((_) async {});

      await secureStorage.updateConnectionData(newData: validData);

      final map = validData.toMap();

      for (final entry in map.entries) {
        verify(mockStorage.write(key: entry.key, value: entry.value)).called(1);
      }

      expect(secureStorage.cachedData, validData);
    });
  });
}
