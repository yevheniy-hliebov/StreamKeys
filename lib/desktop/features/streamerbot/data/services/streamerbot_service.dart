import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_connection_data.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_web_socket.dart';
import 'package:streamkeys/service_locator.dart';

class StreamerBotService {
  final StreamerBotSecureStorage _secureStorage;
  final StreamerBotWebSocket webSocket;

  Timer? _timer;
  final _connectionController = StreamController<ConnectionStatus>.broadcast();
  ConnectionStatus _status = ConnectionStatus.notConnected;

  Stream<ConnectionStatus> get connectionStream => _connectionController.stream;
  ConnectionStatus get status => _status;

  StreamerBotService({
    required StreamerBotSecureStorage secureStorage,
    required this.webSocket,
  }) : _secureStorage = secureStorage;

  Future<void> autoConnect() async {
    final data = await loadData();
    if (data.autoReconnect) {
      await connect();
    }
  }

  Future<void> connect({StreamerBotConnectionData? data}) async {
    _updateConnection(ConnectionStatus.connecting);

    if (data == null && _secureStorage.cachedData == null) {
      await loadData();
    }

    final connectionData = data ?? _secureStorage.cachedData!;
    try {
      await webSocket.connect(
        connectionData.url,
        password: connectionData.password,
      );

      _updateConnection(ConnectionStatus.connected);
      _startAutoReconnectTimer(connectionData);
    } catch (e) {
      _updateConnection(ConnectionStatus.notConnected);
      _log('Connection error: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    _timer?.cancel();
    await webSocket.close();
    _updateConnection(ConnectionStatus.notConnected);
    _log('Disconnected');
  }

  Future<void> reconnect({
    StreamerBotConnectionData? data,
    bool force = false,
  }) async {
    final isConnected = status == ConnectionStatus.connected;

    if (!force && isConnected) {
      _log('StreamerBot already connected, skipping reconnect');
      return;
    }

    _log('Reconnecting...');
    await disconnect();
    await connect(data: data);
  }

  Future<StreamerBotConnectionData> loadData() async {
    final loadedData = await _secureStorage.loadConnectionData();
    if (loadedData == null) {
      _updateConnection(ConnectionStatus.notConnected);
      throw Exception('Connection data not set');
    }
    return loadedData;
  }

  void _startAutoReconnectTimer(StreamerBotConnectionData data) {
    _timer?.cancel();

    if (!data.autoReconnect) {
      _log('Auto reconnect disabled');
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      _log('Auto reconnect triggered');
      try {
        await reconnect();
      } catch (e) {
        _log('Reconnect failed: $e');
      }
    });
  }

  void _updateConnection(ConnectionStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      _connectionController.add(newStatus);
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      print('StreamerBotService: $message');
    }
  }
}
