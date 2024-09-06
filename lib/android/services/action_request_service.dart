import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:streamkeys/android/models/action.dart';

class ActionRequestService {
  int lastOctet;
  final int port = 8080;

  ActionRequestService({
    required this.lastOctet,
  });

  String get host => "192.168.1.$lastOctet";

  String get url => "http://$host:$port";

  Future<List<ButtonAction>> getActions() async {
    final response = await http.get(
      Uri.parse("$url/"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = _decodeResponse(response.bodyBytes);
      print(data);
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
      print(data);
    } else {
      throw Exception(response.body);
    }
  }

  dynamic _decodeResponse(Uint8List bodyBytes) {
    String body = utf8.decode(bodyBytes);
    return jsonDecode(body);
  }
}
