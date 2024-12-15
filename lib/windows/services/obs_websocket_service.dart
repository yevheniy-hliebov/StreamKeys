import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
import 'package:streamkeys/windows/utils/json_read_and_write.dart';

class ObsWebSocketService {
  ObsWebSocket? obs;

  final obsConnectionJson = const JsonReadAndWrite(
    fileName: 'obs_connection.json',
  );

  late OBSConnectionData obsConnectionData;

  FutureVoid getData() async {
    final jsonString = await obsConnectionJson.read();
    if (jsonString.isEmpty) {
      obsConnectionData = OBSConnectionData(url: '', password: '');
      await obsConnectionJson.save(jsonEncode(obsConnectionData.toJson()));
    }
    obsConnectionData = OBSConnectionData.fromJson(jsonDecode(jsonString));
  }

  Future<void> connect() async {
    try {
      obs = await ObsWebSocket.connect(
        obsConnectionData.url,
        password: obsConnectionData.password,
      );
      obsConnectionJson.save(jsonEncode(obsConnectionData.toJson()));
      print("Connected to OBS WebSocket");
    } catch (e) {
      print("Error connecting to OBS WebSocket: $e");
    }
  }

  Future<void> disconnect() async {
    await obs?.close();
    obs = null;
    print("Disconnected from OBS WebSocket");
  }
}

class OBSConnectionData {
  String url;
  String password;

  OBSConnectionData({
    required this.url,
    required this.password,
  });

  factory OBSConnectionData.fromJson(Json json) {
    return OBSConnectionData(
      url: json['url'],
      password: json['password'],
    );
  }

  Json toJson() {
    return {
      'url': url,
      'password': password,
    };
  }
}
