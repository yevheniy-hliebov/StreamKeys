import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streamkeys/core/storage/generic_secure_storage.dart';
import 'package:streamkeys/core/storage/secure_storable.dart';

import 'generic_secure_storage_test.mocks.dart';

class MockConnectionData extends SecureStorable {
  final String ip;
  final String port;

  const MockConnectionData({required this.ip, required this.port});

  @override
  Map<String, String> toMap() => {'ip': ip, 'port': port};

  factory MockConnectionData.fromMap(Map<String, String> map) {
    return MockConnectionData(ip: map['ip']!, port: map['port']!);
  }

  @override
  List<Object?> get props => [ip, port];
}

@GenerateMocks([FlutterSecureStorage])
void main() {
  late MockFlutterSecureStorage mockStorage;
  late GenericSecureStorage<MockConnectionData> storage;

  const validData = MockConnectionData(ip: '192.168.1.1', port: '8080');

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    storage = GenericSecureStorage<MockConnectionData>(
      secureStorage: mockStorage,
      emptyInstance: () => const MockConnectionData(ip: '', port: ''),
      fromMap: (map) => MockConnectionData(ip: map['ip']!, port: map['port']!),
    );
  });

  group('loadConnectionData', () {
    test('returns null if any key is missing', () async {
      when(mockStorage.read(key: 'ip')).thenAnswer((_) async => '192.168.1.1');
      when(mockStorage.read(key: 'port')).thenAnswer((_) async => null);

      final result = await storage.loadConnectionData();

      expect(result, isNull);
      expect(storage.cachedData, isNull);
    });

    test('loads full data and caches it', () async {
      final map = validData.toMap();

      when(mockStorage.read(key: anyNamed('key'))).thenAnswer(
        (invocation) async =>
            map[invocation.namedArguments[const Symbol('key')] as String],
      );

      final result = await storage.loadConnectionData();

      expect(result, equals(validData));
      expect(storage.cachedData, equals(validData));
    });
  });

  group('updateConnectionData', () {
    test('writes only changed keys', () async {
      const oldData = MockConnectionData(ip: '192.168.1.1', port: '8080');
      const newData = MockConnectionData(ip: '192.168.1.1', port: '8081');

      storage.cachedDataForTest = oldData;

      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      await storage.updateConnectionData(newData: newData);

      verify(mockStorage.write(key: 'port', value: '8081')).called(1);
      verifyNever(mockStorage.write(key: 'ip', value: anyNamed('value')));

      expect(storage.cachedData, newData);
    });

    test('writes all keys if no cached data', () async {
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      await storage.updateConnectionData(newData: validData);

      final map = validData.toMap();

      for (final entry in map.entries) {
        verify(mockStorage.write(key: entry.key, value: entry.value)).called(1);
      }

      expect(storage.cachedData, validData);
    });
  });
}
