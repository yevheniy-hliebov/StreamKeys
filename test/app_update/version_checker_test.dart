import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/core/constants/version.dart';
import 'package:streamkeys/desktop/features/app_update/data/services/version_checker.dart';

import 'version_checker_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late VersionChecker checker;

  setUp(() {
    mockClient = MockClient();
    checker = VersionChecker(repo: 'user/repo', client: mockClient);
  });

  group('VersionChecker', () {
    test('returns null on non-200 response', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Error', 500));

      final result = await checker.fetchLatestVersionInfo();
      expect(result, isNull);
    });

    test('returns latest stable version', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async {
          return http.Response(
            jsonEncode([
              {
                'tag_name': 'v1.2.3',
                'prerelease': false,
                'name': 'Release v1.2.3',
                'body': 'Changelog text',
                'assets': [
                  {
                    'name': 'StreamKeys-Windows.zip',
                    'browser_download_url':
                        'https://example.com/StreamKeys-Windows.zip',
                  }
                ],
              },
              {
                'tag_name': 'v1.1.0',
                'prerelease': false,
                'name': 'Release v1.1.0',
                'body': 'Changelog text',
                'assets': [
                  {
                    'name': 'StreamKeys-Windows.zip',
                    'browser_download_url':
                        'https://example.com/StreamKeys-Windows.zip',
                  }
                ],
              },
            ]),
            200,
          );
        },
      );

      final result = await checker.fetchLatestVersionInfo();
      expect(result?.version, 'v1.2.3');
    });

    test('returns latest beta version', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async {
          return http.Response(
            jsonEncode([
              {
                'tag_name': 'v2.0.0-beta',
                'prerelease': true,
                'name': 'Beta v2.0.0',
                'body': 'Changelog text',
                'assets': [
                  {
                    'name': 'StreamKeys-Windows.zip',
                    'browser_download_url':
                        'https://example.com/StreamKeys-Windows.zip',
                  }
                ],
              },
            ]),
            200,
          );
        },
      );

      final result = await checker.fetchLatestVersionInfo(
        mode: AppVersionMode.beta,
      );
      expect(result?.version, 'v2.0.0-beta');
    });
  });
}
