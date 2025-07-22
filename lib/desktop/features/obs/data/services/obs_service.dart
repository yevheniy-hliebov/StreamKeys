import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/core/storage/generic_secure_storage.dart';
import 'package:streamkeys/desktop/features/obs/data/models/obs_connection_data.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_web_socket_factory.dart';

class ObsService {
  final GenericSecureStorage<ObsConnectionData> _secureStorage;
  final ObsWebSocketFactory _obsWebSocketFactory;
  ObsWebSocket? obs;
  Timer? _timer;

  final _connectionController = StreamController<ConnectionStatus>.broadcast();
  Stream<ConnectionStatus> get connectionStream => _connectionController.stream;

  ConnectionStatus _status = ConnectionStatus.notConnected;

  ObsService({
    ObsWebSocketFactory? obsWebSocketFactory,
    required GenericSecureStorage<ObsConnectionData> secureStorage,
  }) : _secureStorage = secureStorage,
       _obsWebSocketFactory =
           obsWebSocketFactory ?? DefaultObsWebSocketFactory();

  ConnectionStatus get status => _status;

  @visibleForTesting
  Timer? get testTimer => _timer;

  Future<void> autoConnect() async {
    final data = await loadData();
    if (data.autoReconnect) {
      await connect();
    }
  }

  Future<void> connect({ObsConnectionData? data}) async {
    _updateConnection(ConnectionStatus.connecting);

    if (_secureStorage.cachedData == null) {
      await loadData();
    }

    try {
      final connectionData = data ?? _secureStorage.cachedData!;

      obs = await _obsWebSocketFactory.connect(
        connectionData.url,
        password: connectionData.password,
        fallbackEventHandler: (Event event) {
          _log('type: ${event.eventType} data: ${event.eventData}');
        },
      );

      _log('Connected to OBS WebSocket');

      _addConnectionHadler();

      _updateConnection(ConnectionStatus.connected);
    } catch (e) {
      _updateConnection(ConnectionStatus.notConnected);
      _log('Error connecting to OBS WebSocket: $e');
      throw Exception('Error connecting to OBS WebSocket: $e');
    } finally {
      _startAutoReconnectTimer();
    }
  }

  Future<void> disconnect() async {
    _timer?.cancel();
    await obs?.close();
    obs = null;
    _updateConnection(ConnectionStatus.notConnected);
    _log('Disconnected from OBS WebSocket');
  }

  void _startAutoReconnectTimer() {
    _timer?.cancel();

    final connectionData = _secureStorage.cachedData;
    if (connectionData == null || !connectionData.autoReconnect) {
      _log('Auto reconnect disabled');
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      _log('Auto reconnect timer triggered');
      try {
        await reconnect();
      } catch (e) {
        _log('Auto reconnect failed: $e');
      }
    });
  }

  Future<void> reconnect({ObsConnectionData? data, bool force = false}) async {
    if (!force && obs != null) {
      try {
        await obs!.general.getStats();
        _updateConnection(ConnectionStatus.connected);
        _log('OBS already connected, skipping reconnect');
        return;
      } catch (e) {
        _log('OBS not responding, reconnecting: $e');
      }
    }

    await disconnect();
    await connect(data: data);
  }

  Future<ObsConnectionData> loadData() async {
    final loadedData = await _secureStorage.loadConnectionData();
    if (loadedData == null) {
      _updateConnection(ConnectionStatus.notConnected);
      throw Exception('Connection data not set');
    }
    return loadedData;
  }

  void _updateConnection(ConnectionStatus status) {
    if (_status != status) {
      _status = status;
      _connectionController.add(status);
    }
  }

  void _addConnectionHadler() {
    obs?.addHandler((event) {
      _log(event.eventType);
      if (event.eventType == 'ExitStarted' ||
          event.eventType == 'ConnectionClosed') {
        _updateConnection(ConnectionStatus.notConnected);
      }
    });
  }

  void _log(String message) {
    if (kDebugMode) {
      print('ObsService: $message');
    }
  }
}
