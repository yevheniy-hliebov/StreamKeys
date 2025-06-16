import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/repositories/deck_page_list_repository.dart';

import '../mocks/mock_local_json_file_manager.mocks.dart';

void main() {
  late DeckPageListRepository repository;
  late MockLocalJsonFileManager mockFileManager;

  setUp(() {
    mockFileManager = MockLocalJsonFileManager();
    repository = DeckPageListRepository(DeckType.grid);
    repository.deckJsonFile = mockFileManager;
  });
  group('DeckPageListRepository', () {
    test('getDeckPageList should return data from existing JSON', () async {
      final Map<String, Object> json = <String, Object>{
        'current_page': 'Main',
        'order_pages': <String>['Main', 'Second']
      };

      when(mockFileManager.read()).thenAnswer((_) async => json);

      final (String, List<String>) result = await repository.getDeckPageList();

      expect(result.$1, 'Main');
      expect(result.$2, <String>['Main', 'Second']);
    });

    test('getDeckPageList should create default JSON if null', () async {
      when(mockFileManager.read()).thenAnswer((_) async => null);
      when(mockFileManager.save(any)).thenAnswer((_) async {});

      final (String, List<String>) result = await repository.getDeckPageList();

      expect(result.$1, 'Default page');
      expect(result.$2, <String>['Default page']);
      verify(mockFileManager.save(any)).called(1);
    });

    test('save should update current_page and order_pages in JSON', () async {
      final Map<String, dynamic> existing = <String, dynamic>{
        'map': <String, Map<String, dynamic>>{
          'Old': <String, dynamic>{},
        }
      };

      when(mockFileManager.read()).thenAnswer((_) async => existing);
      when(mockFileManager.save(any)).thenAnswer((_) async {});

      await repository.save('NewPage', <String>['NewPage', 'AnotherPage']);

      final VerificationResult verification =
          verify(mockFileManager.save(captureAny));
      final Map<String, dynamic> savedJson =
          verification.captured.first as Map<String, dynamic>;

      expect(savedJson['current_page'], 'NewPage');
      expect(savedJson['order_pages'], <String>['NewPage', 'AnotherPage']);
    });
  });
}
