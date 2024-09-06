import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:streamkeys/android/models/action.dart';

class ActionRequestService {
  String lastOctet = '1';
  final int port = 8080;

  String get host => "192.168.1.$lastOctet";

  String get url => "http://$host:$port";

  Future<List<ButtonAction>> getActions() async {
    final response = await http.get(
      Uri.parse("$url/"),
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

  dynamic _decodeResponse(Uint8List bodyBytes) {
    String body = utf8.decode(bodyBytes);
    return jsonDecode(body);
  }
}
