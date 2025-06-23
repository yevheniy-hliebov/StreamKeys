import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/repositorires/key_bindings_repository.dart';

import '../mocks/mock_local_json_file_manager.mocks.dart';

void main() {
  late KeyBindingsRepository repository;
  late MockLocalJsonFileManager mockJsonFile;

  setUp(() {
    mockJsonFile = MockLocalJsonFileManager();
    repository = KeyBindingsRepository(DeckType.grid);
    repository.deckJsonFile = mockJsonFile;
  });

  group('KeyBindingsRepository', () {
    test('getKeyMap returns parsed data from json', () async {
      when(mockJsonFile.read()).thenAnswer(
        (_) async => {
          DeckJsonKeys.currentPageId: 'page1',
          DeckJsonKeys.map: {
            'page1': {
              '1': {
                'name': 'Test Key',
                'backgroundColor': null,
                'imagePath': '',
              },
            },
          },
        },
      );

      final (currentPageId, keyMap) = await repository.getKeyMap();

      expect(currentPageId, 'page1');
      expect(keyMap.length, 1);
      expect(keyMap['page1']?.length, 1);
      expect(keyMap['page1']?[1.toString()]?.name, 'Test Key');
    });

    test('getKeyMap returns empty map when json is null', () async {
      when(mockJsonFile.read()).thenAnswer((_) async => null);
      final (currentPageId, keyMap) = await repository.getKeyMap();

      expect(currentPageId, '');
      expect(keyMap, {});
    });
  });
}
