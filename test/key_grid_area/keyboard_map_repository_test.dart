import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/repositories/keyboard_map_repository.dart';

import '../mocks/mock_local_json_file_manager.mocks.dart';

void main() {
  late MockLocalJsonFileManager mockFileManager;
  late KeyboardMapRepository repository;

  setUp(() {
    mockFileManager = MockLocalJsonFileManager();
    repository = KeyboardMapRepository();

    repository.keyboardMapJsonFile = mockFileManager;
  });
  group('KeyboardMapRepository', () {
    test('loadKeyboardMap returns empty map if JSON is null', () async {
      when(mockFileManager.read()).thenAnswer((_) async => null);

      final Map<String, KeyboardKeyBlock> result =
          await repository.loadKeyboardMap();

      expect(result, isEmpty);
    });

    test('loadKeyboardMap parses valid JSON correctly', () async {
      final Map<String, dynamic> mockJson = <String, dynamic>{
        'function_block': <List<Map<String, dynamic>>>[
          <Map<String, dynamic>>[
            <String, dynamic>{
              'key_code': 27,
              'key_name': 'esc',
              'labels': <String, String>{
                'top-left': '',
                'top-right': '',
                'center': '',
                'bottom-left': 'esc',
                'bottom-right': ''
              }
            },
          ]
        ],
        'main_block': <List<Map<String, dynamic>>>[
          <Map<String, dynamic>>[
            <String, dynamic>{
              'key_code': 192,
              'key_name': '`',
              'labels': <String, String>{
                'top-left': '` ~',
                'top-right': '',
                'center': '',
                'bottom-left': '',
                'bottom-right': ''
              }
            }
          ]
        ],
        'navigation_block': <List<Map<String, dynamic>>>[
          <Map<String, dynamic>>[
            <String, dynamic>{
              'key_code': 255,
              'key_name': 'print screen',
              'labels': <String, String>{
                'top-left': '',
                'top-right': '',
                'center': '',
                'bottom-left': 'ps',
                'bottom-right': ''
              }
            }
          ]
        ],
        'numpad_block': <List<Map<String, dynamic>>>[
          <Map<String, dynamic>>[
            <String, dynamic>{
              'key_code': 144,
              'key_name': 'num lock',
              'labels': <String, String>{
                'top-left': '',
                'top-right': '',
                'center': '',
                'bottom-left': 'num',
                'bottom-right': ''
              }
            }
          ]
        ],
      };

      when(mockFileManager.read()).thenAnswer((_) async => mockJson);

      final Map<String, KeyboardKeyBlock> result =
          await repository.loadKeyboardMap();

      expect(result, isNotEmpty);

      expect(result[KeyboardMapRepository.functionsBlockKey]!.length, 1);
      expect(
          result[KeyboardMapRepository.functionsBlockKey]![0][0].keyCode, 27);
      expect(
          result[KeyboardMapRepository.functionsBlockKey]![0][0].name, 'esc');

      expect(result[KeyboardMapRepository.mainBlockKey]!.length, 1);
      expect(result[KeyboardMapRepository.mainBlockKey]![0][0].keyCode, 192);
      expect(result[KeyboardMapRepository.mainBlockKey]![0][0].name, '`');

      expect(result[KeyboardMapRepository.navigationBlockKey]!.length, 1);
      expect(
          result[KeyboardMapRepository.navigationBlockKey]![0][0].keyCode, 255);
      expect(result[KeyboardMapRepository.navigationBlockKey]![0][0].name,
          'print screen');

      expect(result[KeyboardMapRepository.numpadBlockKey]!.length, 1);
      expect(result[KeyboardMapRepository.numpadBlockKey]![0][0].keyCode, 144);
      expect(
          result[KeyboardMapRepository.numpadBlockKey]![0][0].name, 'num lock');
    });
  });
}
