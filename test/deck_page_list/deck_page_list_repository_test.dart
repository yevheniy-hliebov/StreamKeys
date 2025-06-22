import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/repositories/deck_page_list_repository.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_page.dart';

import '../mocks/mock_local_json_file_manager.mocks.dart';

void main() {
  late DeckPageListRepository repository;
  late MockLocalJsonFileManager mockFileManager;

  final mockJson = {
    DeckJsonKeys.currentPageId: '123',
    DeckJsonKeys.orderPages: <Map<String, dynamic>>[
      {
        DeckJsonKeys.pageId: '123',
        DeckJsonKeys.pageName: 'Test Page',
      }
    ],
    DeckJsonKeys.map: {
      '123': <String, dynamic>{},
    }
  };

  setUp(() {
    mockFileManager = MockLocalJsonFileManager();
    repository = DeckPageListRepository(
      DeckType.grid,
      jsonFile: mockFileManager,
    );
  });

  group('DeckPageListRepository', () {
    test(
      'init: load json',
      () async {
        final initialJson = Map<String, dynamic>.from(mockJson);
        when(mockFileManager.read()).thenAnswer((_) async => initialJson);

        await repository.init();

        expect(repository.currentPageId, '123');
        expect(repository.orderPages.first.name, 'Test Page');
      },
    );

    test(
      'init: generate json if json file is empty',
      () async {
        when(mockFileManager.read()).thenAnswer((_) async => null);
        when(mockFileManager.save(any)).thenAnswer((_) async => {});

        await repository.init();

        expect(repository.json.containsKey(DeckJsonKeys.currentPageId), isTrue);
        expect(repository.json.containsKey(DeckJsonKeys.orderPages), isTrue);
        expect(repository.json.containsKey(DeckJsonKeys.map), isTrue);
        expect(repository.orderPages.length, 1);
        expect(repository.orderPages.first.name, 'Default page');
      },
    );

    test(
      'addAndSelectPage: adds page, selects it, updates map and saves',
      () async {
        final initialJson = Map<String, dynamic>.from(mockJson);
        when(mockFileManager.read()).thenAnswer((_) async => initialJson);
        when(mockFileManager.save(any)).thenAnswer((_) async {});

        await repository.init();

        final newPage = DeckPage.create(name: 'New Page');

        await repository.addAndSelectPage(newPage);

        expect(repository.currentPageId, newPage.id);
        expect(repository.orderPages.any((p) => p == newPage), isTrue);
        expect(
          repository.json[DeckJsonKeys.map][newPage.id],
          isA<Map<String, dynamic>>(),
        );
        verify(mockFileManager.save(any)).called(1);
      },
    );

    test(
      'selectPage: updates current_page_id and saves',
      () async {
        final initialJson = Map<String, dynamic>.from(mockJson);
        when(mockFileManager.read()).thenAnswer((_) async => initialJson);
        when(mockFileManager.save(any)).thenAnswer((_) async {});

        await repository.init();

        const newPageId = 'new_id';
        await repository.selectPage(newPageId);

        expect(repository.currentPageId, newPageId);
        verify(mockFileManager.save(any)).called(1);
      },
    );

    test(
      'renameCurrentPage: renames current page and saves',
      () async {
        final initialJson = Map<String, dynamic>.from(mockJson);
        when(mockFileManager.read()).thenAnswer((_) async => initialJson);
        when(mockFileManager.save(any)).thenAnswer((_) async {});

        await repository.init();

        await repository.renameCurrentPage('New Name');

        final renamedPage =
            repository.orderPages.firstWhere((p) => p.id == '123');
        expect(renamedPage.name, 'New Name');
        verify(mockFileManager.save(any)).called(1);
      },
    );

    test(
      'renameCurrentPage: does nothing if current page id not found',
      () async {
        final initialJson = Map<String, dynamic>.from(mockJson);
        initialJson[DeckJsonKeys.currentPageId] = 'missing_id';

        when(mockFileManager.read()).thenAnswer((_) async => initialJson);
        when(mockFileManager.save(any)).thenAnswer((_) async {});

        await repository.init();

        await repository.renameCurrentPage('New Name');

        final page = repository.orderPages.firstWhere((p) => p.id == '123');
        expect(page.name, 'New Name');
        verifyNever(mockFileManager.save(any));
      },
    );

    test(
      'deletePage: deletes page and selects fallback page, then saves',
      () async {
        final initialJson = {
          DeckJsonKeys.currentPageId: 'page2',
          DeckJsonKeys.orderPages: <Map<String, dynamic>>[
            {DeckJsonKeys.pageId: 'page1', DeckJsonKeys.pageName: 'Page 1'},
            {DeckJsonKeys.pageId: 'page2', DeckJsonKeys.pageName: 'Page 2'},
            {DeckJsonKeys.pageId: 'page3', DeckJsonKeys.pageName: 'Page 3'},
          ],
          DeckJsonKeys.map: <String, dynamic>{
            'page1': {},
            'page2': {},
            'page3': {},
          }
        };

        when(mockFileManager.read()).thenAnswer((_) async => initialJson);
        when(mockFileManager.save(any)).thenAnswer((_) async {});

        await repository.init();

        await repository.deletePage('page2');

        expect(repository.orderPages.length, 2);
        expect(repository.orderPages.any((p) => p.id == 'page2'), isFalse);
        expect(repository.json[DeckJsonKeys.map].containsKey('page2'), isFalse);

        expect(repository.currentPageId, anyOf('page1', 'page3'));

        verify(mockFileManager.save(any)).called(1);
      },
    );

    test(
      'deletePage: does not delete if only one page',
      () async {
        final initialJson = {
          DeckJsonKeys.currentPageId: 'onlyPage',
          DeckJsonKeys.orderPages: <Map<String, dynamic>>[
            {
              DeckJsonKeys.pageId: 'onlyPage',
              DeckJsonKeys.pageName: 'Only Page',
            },
          ],
          DeckJsonKeys.map: <String, dynamic>{
            'onlyPage': {},
          }
        };

        when(mockFileManager.read()).thenAnswer((_) async => initialJson);
        when(mockFileManager.save(any)).thenAnswer((_) async {});

        await repository.init();

        await repository.deletePage('onlyPage');

        expect(repository.orderPages.length, 1);
        expect(repository.orderPages.first.id, 'onlyPage');

        verifyNever(mockFileManager.save(any));
      },
    );

    test(
      'deletePage: does nothing if page not found',
      () async {
        final initialJson = {
          DeckJsonKeys.currentPageId: 'page1',
          DeckJsonKeys.orderPages: <Map<String, dynamic>>[
            {DeckJsonKeys.pageId: 'page1', DeckJsonKeys.pageName: 'Page 1'},
            {DeckJsonKeys.pageId: 'page2', DeckJsonKeys.pageName: 'Page 2'},
          ],
          DeckJsonKeys.map: <String, dynamic>{
            'page1': {},
            'page2': {},
          }
        };

        when(mockFileManager.read()).thenAnswer((_) async => initialJson);
        when(mockFileManager.save(any)).thenAnswer((_) async {});

        await repository.init();

        await repository.deletePage('missingPage');

        expect(repository.orderPages.length, 2);
        verifyNever(mockFileManager.save(any));
      },
    );

    test('reorderPages: moves item to new index and saves', () async {
      final initialJson = {
        DeckJsonKeys.currentPageId: 'page1',
        DeckJsonKeys.orderPages: <Map<String, dynamic>>[
          {DeckJsonKeys.pageId: 'page1', DeckJsonKeys.pageName: 'Page 1'},
          {DeckJsonKeys.pageId: 'page2', DeckJsonKeys.pageName: 'Page 2'},
          {DeckJsonKeys.pageId: 'page3', DeckJsonKeys.pageName: 'Page 3'},
        ],
        DeckJsonKeys.map: <String, dynamic>{
          'page1': {},
          'page2': {},
          'page3': {},
        }
      };

      when(mockFileManager.read()).thenAnswer((_) async => initialJson);
      when(mockFileManager.save(any)).thenAnswer((_) async {});

      await repository.init();

      await repository.reorderPages(0, 2);

      final reordered = repository.orderPages;
      expect(reordered[0].id, 'page2');
      expect(reordered[1].id, 'page1');
      expect(reordered[2].id, 'page3');

      verify(mockFileManager.save(any)).called(1);
    });
  });
}
