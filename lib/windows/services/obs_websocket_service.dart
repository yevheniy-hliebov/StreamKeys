import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/models/obs_connection_data.dart';
import 'package:streamkeys/windows/utils/json_read_and_write.dart';

class ObsWebSocketService {
  ObsWebSocket? obs;

  bool isConnected = false;
  String? errorMessage;

  final urlController = TextEditingController();
  final passwordController = TextEditingController();

  final obsConnectionJson = const JsonReadAndWrite(
    fileName: 'obs_connection.json',
  );

  late OBSConnectionData obsConnectionData;

  final VoidCallback? notifyListeners;

  ObsWebSocketService(this.notifyListeners);

  FutureVoid init() async {
    await getObsConnectionData();

    urlController.text = obsConnectionData.url;
    passwordController.text = obsConnectionData.password;
    urlController.addListener(() {
      obsConnectionData.url = urlController.text;
      notifyListeners?.call();
    });
    passwordController.addListener(() {
      obsConnectionData.password = passwordController.text;
      notifyListeners?.call();
    });
    notifyListeners?.call();
  }

  FutureVoid getObsConnectionData() async {
    final jsonString = await obsConnectionJson.read();
    if (jsonString.isEmpty) {
      obsConnectionData = OBSConnectionData(url: '', password: '');
      await obsConnectionJson.save(jsonEncode(obsConnectionData.toJson()));
    }
    obsConnectionData = OBSConnectionData.fromJson(jsonDecode(jsonString));
    notifyListeners?.call();
  }

  Future<void> connect() async {
    try {
      if (obsConnectionData.url.isEmpty || obsConnectionData.password.isEmpty) {
        isConnected = false;
      }

      obs = await ObsWebSocket.connect(
        obsConnectionData.url,
        password: obsConnectionData.password,
      );
      obsConnectionJson.save(jsonEncode(obsConnectionData.toJson()));

      isConnected = true;
      if (kDebugMode) {
        print("Connected to OBS WebSocket");
      }
    } catch (e) {
      errorMessage = e.toString();
      isConnected = false;
      if (kDebugMode) {
        print("Error connecting to OBS WebSocket: $e");
      }
    }
    notifyListeners?.call();
  }

  Future<void> disconnect() async {
    await obs?.close();
    obs = null;

    isConnected = false;
    if (kDebugMode) {
      print("Disconnected from OBS WebSocket");
    }
    notifyListeners?.call();
  }
}
