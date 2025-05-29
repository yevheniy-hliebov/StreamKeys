import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/features/obs/data/models/obs_connection_data.dart';

class ObsConnectionRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  ObsWebSocket? _obs;
  ObsConnectionData? connectionData;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  static const _ipKey = 'obs_ip';
  static const _portKey = 'obs_port';
  static const _passwordKey = 'obs_password';
  static const _autoReconnectKey = 'obs_auto_reconnect';

  Future<ObsConnectionData?> loadConnectionData() async {
    final ip = await _storage.read(key: _ipKey);
    final port = await _storage.read(key: _portKey);
    final password = await _storage.read(key: _passwordKey);
    if (ip == null || port == null || password == null) return null;

    connectionData = ObsConnectionData(ip: ip, port: port, password: password);
    return connectionData;
  }

  Future<void> updateConnectionData(ObsConnectionData newData) async {
    if (connectionData == newData) return;

    await _storage.write(key: _ipKey, value: newData.ip);
    await _storage.write(key: _portKey, value: newData.port);
    await _storage.write(key: _passwordKey, value: newData.password);

    connectionData = newData;
  }

  // Нові методи для автоперепідключення

  Future<bool> loadAutoReconnect() async {
    final value = await _storage.read(key: _autoReconnectKey);
    return value == 'true';
  }

  Future<void> saveAutoReconnect(bool enabled) async {
    await _storage.write(key: _autoReconnectKey, value: enabled ? 'true' : 'false');
  }

  Future<void> connect() async {
    if (connectionData == null) {
      throw Exception('Connection data not set');
    }

    try {
      _obs = await ObsWebSocket.connect(
        connectionData!.url,
        password: connectionData!.password,
        fallbackEventHandler: (Event event) {
          if (kDebugMode) {
            print('type: ${event.eventType} data: ${event.eventData}');
          }
        },
      );
      if (kDebugMode) {
        print("Connected to OBS WebSocket");
      }

      _obs?.addHandler((event) {
        print(event.eventType);
        if (event.eventType == 'ExitStarted' ||
            event.eventType == 'ConnectionClosed') {
          _isConnected = false;
        }
      });
      _isConnected = true;
    } catch (e) {
      if (kDebugMode) {
        print("Error connecting to OBS WebSocket: $e");
      }
      throw Exception("Error connecting to OBS WebSocket: $e");
    }
  }

  Future<void> disconnect() async {
    await _obs?.close();
    _obs = null;
    _isConnected = false;

    if (kDebugMode) {
      print("Disconnected from OBS WebSocket");
    }
  }

  Future<void> reconnect() async {
    await disconnect();
    await connect();
  }
}
