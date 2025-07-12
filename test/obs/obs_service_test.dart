import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:obs_websocket/request.dart';
import 'package:streamkeys/desktop/features/obs/data/models/obs_connection_data.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_web_socket_factory.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_secure_storage.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_service.dart';
import 'package:obs_websocket/obs_websocket.dart';

import 'obs_service_test.mocks.dart';

class FakeObsConnectionData extends ObsConnectionData {
  @override
  String get url => 'ws://localhost:4455';

  const FakeObsConnectionData({
    super.ip = 'localhost',
    super.port = '4455',
    super.password = 'password',
    super.autoReconnect = true,
  });
}

@GenerateMocks([
  ObsSecureStorage,
  ObsWebSocketFactory,
  ObsWebSocket,
  General,
  StatsResponse,
])
void main() {
  late MockObsSecureStorage mockStorage;
  late MockObsWebSocketFactory mockObsWebSocketFactory;
  late ObsService service;

  setUp(() {
    mockStorage = MockObsSecureStorage();
    mockObsWebSocketFactory = MockObsWebSocketFactory();
    service = ObsService(
      secureStorage: mockStorage,
      obsWebSocketFactory: mockObsWebSocketFactory,
    );
  });

  group('ObsService', () {
    test('throws if connection data is null', () async {
      when(mockStorage.cachedData).thenReturn(null);
      when(mockStorage.loadConnectionData()).thenAnswer((_) async => null);

      expect(() => service.connect(), throwsException);
      expect(service.status, ConnectionStatus.connecting);
    });

    test('connects successfully', () async {
      const fakeData = FakeObsConnectionData();
      final mockWebSocket = MockObsWebSocket();
      final mockFactory = MockObsWebSocketFactory();

      when(mockStorage.cachedData).thenReturn(fakeData);
      when(mockStorage.loadConnectionData()).thenAnswer((_) async => fakeData);

      when(mockFactory.connect(
        any,
        password: anyNamed('password'),
        fallbackEventHandler: anyNamed('fallbackEventHandler'),
      )).thenAnswer((_) async => mockWebSocket);

      service = ObsService(
        secureStorage: mockStorage,
        obsWebSocketFactory: mockFactory,
      );

      await service.connect();

      expect(service.status, ConnectionStatus.connected);
      expect(service.obs, mockWebSocket);
    });

    test('disconnect sets status to notConnected', () async {
      service.obs = MockObsWebSocket();
      await service.disconnect();
      expect(service.status, ConnectionStatus.notConnected);
      expect(service.obs, isNull);
    });

    test('reconnect skips if already connected', () async {
      final mockWebSocket = MockObsWebSocket();
      final mockGeneral = MockGeneral();
      final mockStats = MockStatsResponse();

      when(mockWebSocket.general).thenReturn(mockGeneral);
      when(mockGeneral.getStats()).thenAnswer((_) async => mockStats);

      service.obs = mockWebSocket;

      await service.reconnect();

      expect(service.status, ConnectionStatus.connected);
    });

    test('startAutoReconnectTimer does nothing if autoReconnect is false', () {
      when(mockStorage.cachedData)
          .thenReturn(const FakeObsConnectionData(autoReconnect: false));

      service.startAutoReconnectTimer();

      expect(service.testTimer, isNull);

      expect(service.status, ConnectionStatus.notConnected);
    });
  });
}
