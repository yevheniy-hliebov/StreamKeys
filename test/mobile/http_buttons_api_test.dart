import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/core/storage/generic_secure_storage.dart';
import 'package:streamkeys/mobile/features/api_connection/data/models/api_connection_data.dart';
import 'package:streamkeys/mobile/features/buttons/data/models/http_buttons_response.dart';
import 'package:streamkeys/mobile/features/buttons/data/models/http_button_image_response.dart';
import 'package:streamkeys/mobile/features/buttons/data/services/http_buttons_api.dart';

import 'http_buttons_api_test.mocks.dart';

@GenerateMocks([GenericSecureStorage, http.Client])
void main() {
  late MockGenericSecureStorage<ApiConnectionData> mockStorage;
  late MockClient mockClient;
  late HttpButtonsApi api;

  const password = 'testpass';
  const mockConnectionData = ApiConnectionData(
    ip: '127.0.0.1',
    port: '8080',
    password: password,
  );

  setUp(() {
    mockStorage = MockGenericSecureStorage<ApiConnectionData>();
    mockClient = MockClient();

    when(mockStorage.cachedData).thenReturn(mockConnectionData);
    api = HttpButtonsApi(mockStorage, client: mockClient);
  });

  group('HttpButtonsApi getButtons', () {
    test('returns buttons response on success', () async {
      final fakeJson = {
        'grid_template': {
          'type': '3x2',
          'columns': 3,
          'rows': 2,
        },
        'current_page_id': 'current_id',
        'page_map': {}
      };

      when(mockClient.get(
        Uri.parse('${mockConnectionData.url}/api/grid/buttons'),
        headers: {'X-Api-Password': password},
      )).thenAnswer((_) async => http.Response(jsonEncode(fakeJson), 200));

      final result = await api.getButtons();

      expect(result, isA<HttpButtonsResponse>());
      expect(result.pageMap, isEmpty);
    });

    test('throws exception on non-200 response', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(() => api.getButtons(), throwsException);
    });
  });

  group('HttpButtonsApi getImage', () {
    test('returns image response on success', () async {
      final bytes = Uint8List.fromList([0, 1, 2]);

      when(mockClient.get(
        Uri.parse('${mockConnectionData.url}/api/grid/A/image'),
        headers: {'X-Api-Password': password},
      )).thenAnswer((_) async => http.Response.bytes(
            bytes,
            200,
            headers: {'content-type': 'image/png'},
          ));

      final result = await api.getImage('A');

      expect(result, isA<HttpButtonImageResponse>());
      expect(result.bytes, equals(bytes));
      expect(result.contentType, 'image/png');
    });

    test('throws exception on failure', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('error', 404));

      expect(() => api.getImage('A'), throwsException);
    });
  });

  group('HttpButtonsApi clickButton', () {
    test('succeeds on 200', () async {
      when(mockClient.post(
        Uri.parse('${mockConnectionData.url}/api/grid/A'),
        headers: {'X-Api-Password': password},
      )).thenAnswer((_) async => http.Response('', 200));

      await api.clickButton('A');
    });

    test('throws on failure', () async {
      when(mockClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('error', 400));

      expect(() => api.clickButton('A'), throwsException);
    });
  });

  group('HttpButtonsApi _checkConnectionData', () {
    test('throws when cachedData and storage return null', () async {
      when(mockStorage.cachedData).thenReturn(null);
      when(mockStorage.loadConnectionData()).thenAnswer((_) async => null);

      final apiNoData = HttpButtonsApi(mockStorage, client: mockClient);

      expect(() => apiNoData.getButtons(), throwsException);
    });
  });
}
