import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_connection_data.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_web_socket.dart';
import 'package:streamkeys/service_locator.dart';

import 'streamerbot_service_test.mocks.dart';

@GenerateMocks([GenericSecureStorage, StreamerBotWebSocket])
void main() {
  late MockGenericSecureStorage<StreamerBotConnectionData> mockStorage;
  late MockStreamerBotWebSocket mockWebSocket;
  late StreamerBotService service;

  const testData = StreamerBotConnectionData(
    ip: 'localhost',
    port: '8080',
    password: 'pass',
    autoReconnect: false,
  );

  setUp(() {
    mockStorage = MockGenericSecureStorage();
    mockWebSocket = MockStreamerBotWebSocket();
    service = StreamerBotService(
      secureStorage: mockStorage,
      webSocket: mockWebSocket,
    );
  });

  group('StreamerBotService', () {
    test('connect succeeds and updates status to connected', () async {
      when(mockStorage.cachedData).thenReturn(testData);
      when(mockWebSocket.connect(any, password: anyNamed('password')))
          .thenAnswer(
        (_) async {},
      );

      await service.connect();

      expect(service.status, ConnectionStatus.connected);
      verify(mockWebSocket.connect(testData.url, password: testData.password))
          .called(1);
    });

    test('connect fails and status becomes notConnected', () async {
      when(mockStorage.cachedData).thenReturn(testData);
      when(mockWebSocket.connect(any, password: anyNamed('password')))
          .thenThrow(
        Exception('Connection failed'),
      );

      expect(
        () => service.connect(),
        throwsA(isA<Exception>()),
      );

      await Future.delayed(Duration.zero);
      expect(service.status, ConnectionStatus.notConnected);
    });

    test('disconnect cancels timer and closes socket', () async {
      when(mockWebSocket.close()).thenAnswer((_) async {});

      await service.disconnect();

      expect(service.status, ConnectionStatus.notConnected);
      verify(mockWebSocket.close()).called(1);
    });

    test('reconnect skips if already connected and not forced', () async {
      when(mockStorage.cachedData).thenReturn(testData);
      when(mockWebSocket.connect(any, password: anyNamed('password')))
          .thenAnswer(
        (_) async {},
      );

      await service.connect();

      await service.reconnect();

      verifyNever(mockWebSocket.close());
    });

    test('autoConnect connects if autoReconnect is true', () async {
      final autoReconnectData = StreamerBotConnectionData(
        ip: testData.ip,
        port: testData.port,
        password: testData.password,
        autoReconnect: true,
      );
      when(mockStorage.loadConnectionData()).thenAnswer(
        (_) async => autoReconnectData,
      );
      when(mockStorage.cachedData).thenReturn(autoReconnectData);
      when(mockWebSocket.connect(any, password: anyNamed('password')))
          .thenAnswer(
        (_) async {},
      );

      await service.autoConnect();

      expect(service.status, ConnectionStatus.connected);
    });

    test('loadData throws if no data in storage', () async {
      when(mockStorage.loadConnectionData()).thenAnswer((_) async => null);

      expect(() => service.loadData(), throwsA(isA<Exception>()));
    });

    test('loadData returns valid data and keeps status', () async {
      when(mockStorage.loadConnectionData()).thenAnswer((_) async => testData);

      final result = await service.loadData();

      expect(result, testData);
    });
  });
}
