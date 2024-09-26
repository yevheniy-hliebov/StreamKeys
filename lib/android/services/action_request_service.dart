import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:streamkeys/android/models/action.dart';
import 'package:streamkeys/android/models/device_info.dart';

class ActionRequestService {
  String host = '192.168.1.1';
  final int port = 8080;

  String get url => "http://$host:$port";

  static Future<DeviceInfo> getDeviceName(String host, int port) async {
    final response = await http.get(
      Uri.parse("http://$host:$port/device-name"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return DeviceInfo(ip: host, port: port, name: response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<ButtonAction>> getActions() async {
    final response = await http.get(
      Uri.parse("$url/actions"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = _decodeResponse(response.bodyBytes);
      return ButtonAction.fromArrayJson(data);
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> clickAction(int id) async {
    final response = await http.get(
      Uri.parse("$url/$id/click"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = response.body;
      if (kDebugMode) {
        print(data);
      }
    } else {
      throw Exception(response.body);
    }
  }

  static dynamic _decodeResponse(Uint8List bodyBytes) {
    String body = utf8.decode(bodyBytes);
    return jsonDecode(body);
  }
}
