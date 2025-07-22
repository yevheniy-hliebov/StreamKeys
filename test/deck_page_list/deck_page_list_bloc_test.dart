import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_page.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/repositories/deck_page_list_repository.dart';

class MockDeckPageListRepository extends Mock
    implements DeckPageListRepository {}

void main() {
  late MockDeckPageListRepository mockRepository;
  final mockPage = DeckPage(id: '123', name: 'Test Page');

  setUpAll(() {
    registerFallbackValue(mockPage);
  });

  setUp(() {
    mockRepository = MockDeckPageListRepository();
  });

  void verifyRepositoryCalls(MockDeckPageListRepository repo, {int times = 1}) {
    verify(() => repo.currentPageId).called(times);
    verify(() => repo.orderPages).called(greaterThanOrEqualTo(times));
  }

  group('DeckPageListBloc', () {
    blocTest<DeckPageListBloc, DeckPageListState>(
      'emits DeckPageListLoaded after successful init',
      build: () {
        when(() => mockRepository.init()).thenAnswer((_) async {});
        when(() => mockRepository.currentPageId).thenReturn(mockPage.id);
        when(() => mockRepository.orderPages).thenReturn([mockPage]);

        return DeckPageListBloc(mockRepository);
      },
      act: (bloc) => bloc.add(DeckPageListInit()),
      expect: () => [
        DeckPageListLoaded(
          currentPageId: mockPage.id,
          pages: [mockPage],
          isEditing: false,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.init()).called(1);
        verifyRepositoryCalls(mockRepository);
      },
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'emits DeckPageListLoaded after adding new page',
      build: () {
        when(() => mockRepository.orderPages).thenReturn([]);
        when(() => mockRepository.addAndSelectPage(any<DeckPage>())).thenAnswer(
          (_) async {},
        );
        when(() => mockRepository.currentPageId).thenReturn(mockPage.id);
        when(() => mockRepository.orderPages).thenReturn([mockPage]);

        return DeckPageListBloc(mockRepository);
      },
      act: (bloc) => bloc.add(DeckPageListAddPage()),
      expect: () => [
        DeckPageListLoaded(
          currentPageId: mockPage.id,
          pages: [mockPage],
          isEditing: false,
        ),
      ],
      verify: (_) {
        verify(() {
          return mockRepository.addAndSelectPage(any<DeckPage>());
        }).called(1);
        verifyRepositoryCalls(mockRepository);
      },
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'emits DeckPageListLoaded after selecting a page',
      build: () {
        when(() => mockRepository.selectPage(any())).thenAnswer((_) async {});
        when(() => mockRepository.currentPageId).thenReturn(mockPage.id);
        when(() => mockRepository.orderPages).thenReturn([mockPage]);

        return DeckPageListBloc(mockRepository);
      },
      act: (bloc) => bloc.add(DeckPageListSelectPage(mockPage.id)),
      expect: () => [
        DeckPageListLoaded(
          currentPageId: mockPage.id,
          pages: [mockPage],
          isEditing: false,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.selectPage(mockPage.id)).called(1);
        verifyRepositoryCalls(mockRepository);
      },
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'emits DeckPageListLoaded after deleting current page',
      build: () {
        int callCount = 0;
        mockRepository = MockDeckPageListRepository();
        when(() => mockRepository.currentPageId).thenAnswer((_) {
          callCount++;
          return callCount == 1 ? 'page_to_delete' : mockPage.id;
        });
        when(() => mockRepository.deletePage(any())).thenAnswer((_) async {});
        when(() => mockRepository.orderPages).thenReturn(<DeckPage>[mockPage]);

        return DeckPageListBloc(mockRepository);
      },
      act: (bloc) => bloc.add(DeckPageListDeletePage()),
      verify: (_) {
        verify(() => mockRepository.deletePage('page_to_delete')).called(1);
      },
      expect: () => [
        DeckPageListLoaded(
          currentPageId: mockPage.id,
          pages: [mockPage],
          isEditing: false,
        ),
      ],
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'emits DeckPageListLoaded with isEdit true after starting editing',
      build: () {
        mockRepository = MockDeckPageListRepository();
        when(() => mockRepository.currentPageId).thenReturn(mockPage.id);
        when(() => mockRepository.orderPages).thenReturn(<DeckPage>[mockPage]);

        return DeckPageListBloc(mockRepository);
      },
      act: (bloc) => bloc.add(DeckPageListStartEditingPage()),
      verify: (_) {
        verifyRepositoryCalls(mockRepository);
      },
      expect: () => [
        predicate<DeckPageListState>((state) {
          return state is DeckPageListLoaded && state.isEditing == true;
        }),
      ],
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'emits DeckPageListLoaded after stopping editing and renaming page',
      build: () {
        mockRepository = MockDeckPageListRepository();

        when(() => mockRepository.renameCurrentPage(any())).thenAnswer(
          (_) async {},
        );
        when(() => mockRepository.currentPageId).thenReturn(mockPage.id);
        when(() => mockRepository.orderPages).thenReturn(
          [DeckPage(id: mockPage.id, name: 'New Name')],
        );

        return DeckPageListBloc(mockRepository);
      },
      act: (bloc) => bloc.add(
        const DeckPageListStopEditingPage('New Name'),
      ),
      verify: (_) {
        verify(() => mockRepository.renameCurrentPage('New Name')).called(1);
        verifyRepositoryCalls(mockRepository);
      },
      expect: () => [
        DeckPageListLoaded(
          currentPageId: mockPage.id,
          pages: [DeckPage(id: mockPage.id, name: 'New Name')],
          isEditing: false,
        ),
      ],
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'emits DeckPageListLoaded after reordering pages',
      build: () {
        mockRepository = MockDeckPageListRepository();

        when(() => mockRepository.reorderPages(0, 2)).thenAnswer(
          (_) async {},
        );
        when(() => mockRepository.currentPageId).thenReturn(mockPage.id);
        when(() => mockRepository.orderPages).thenReturn(<DeckPage>[
          DeckPage(id: '2', name: 'second page'),
          mockPage,
        ]);

        return DeckPageListBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const DeckPageListReorder(0, 2)),
      verify: (_) {
        verify(() => mockRepository.reorderPages(0, 2)).called(1);
        verifyRepositoryCalls(mockRepository);
      },
      expect: () => [
        DeckPageListLoaded(
          currentPageId: mockPage.id,
          pages: [
            DeckPage(id: '2', name: 'second page'),
            mockPage,
          ],
          isEditing: false,
        ),
      ],
    );
  });
}
