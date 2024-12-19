import 'dart:async';
import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/server/server.dart';
import 'package:streamkeys/windows/services/obs_websocket_service.dart';

class ServerProvider extends ChangeNotifier {
  final Server _server = Server();
  late ObsWebSocketService _obsWebSocketService;
  Timer? _reconnectTimer;

  bool isConnecting = false;

  ServerProvider() {
    _obsWebSocketService = ObsWebSocketService(notifyListeners);
    init();
  }

  bool get isOBSConnected => _obsWebSocketService.isConnected;
  ObsWebSocketService get obsWebSocketService => _obsWebSocketService;

  FutureVoid init() async {
    await _obsWebSocketService.init();
    await reconnect();

    await _server.start(_obsWebSocketService);

    _startReconnectTimer();
  }

  FutureVoid reconnect() async {
    isConnecting = true;
    notifyListeners();

    await _obsWebSocketService.connect();

    isConnecting = false;
    notifyListeners();
  }

  void _startReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) async {
      await reconnect();
    });
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    super.dispose();
  }
}
