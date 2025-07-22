import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:streamkeys/core/storage/generic_secure_storage.dart';
import 'package:streamkeys/mobile/features/api_connection/data/models/api_connection_data.dart';
import 'package:streamkeys/mobile/features/buttons/data/models/http_button_image_response.dart';
import 'package:streamkeys/mobile/features/buttons/data/models/http_buttons_response.dart';

class HttpButtonsApi {
  final GenericSecureStorage<ApiConnectionData> _secureStorage;
  final http.Client _client;

  HttpButtonsApi(this._secureStorage, {http.Client? client})
    : _client = client ?? http.Client();

  Uri _buildUri(String path) {
    return Uri.parse('${_secureStorage.cachedData?.url}/api/grid/$path');
  }

  Future<HttpButtonsResponse> getButtons() async {
    await _checkConnectionData();

    final uri = _buildUri('buttons');
    final response = await _client.get(uri, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception('Failed to load buttons: ${response.body}');
    }

    final json = jsonDecode(response.body);
    return HttpButtonsResponse.fromJson(json);
  }

  Future<HttpButtonImageResponse> getImage(String keyCode) async {
    await _checkConnectionData();

    final uri = _buildUri('$keyCode/image');
    final response = await _client.get(uri, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception('Failed to load image for key $keyCode');
    }

    final contentType = response.headers['content-type'] ?? 'image/jpeg';
    final bytes = response.bodyBytes;

    return HttpButtonImageResponse(bytes: bytes, contentType: contentType);
  }

  Future<void> clickButton(String keyCode) async {
    await _checkConnectionData();

    final uri = _buildUri(keyCode);
    final response = await _client.post(uri, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception('Failed to click button $keyCode: ${response.body}');
    }
  }

  Future<void> _checkConnectionData() async {
    if (_secureStorage.cachedData == null) {
      final loadConnectionData = await _secureStorage.loadConnectionData();
      if (loadConnectionData == null || loadConnectionData.isEmpty) {
        throw Exception('Connection data is missing or empty');
      }
    }
  }

  Map<String, String> _headers() {
    return {'X-Api-Password': _secureStorage.cachedData?.password ?? ''};
  }
}
