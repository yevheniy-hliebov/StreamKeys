import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/repositories/deck_page_list_repository.dart';

class MockDeckPageListRepository extends Mock
    implements DeckPageListRepository {}

void main() {
  late DeckPageListRepository repository;

  setUp(() {
    repository = MockDeckPageListRepository();
  });

  group('DeckPageListBloc', () {
    blocTest<DeckPageListBloc, DeckPageListState>(
      'Init: emits loaded state with default page',
      build: () {
        when(() => repository.getDeckPageList()).thenAnswer(
          (_) async => ('Default page', <String>['Default page']),
        );
        when(() => repository.save(any(), any())).thenAnswer((_) async {});
        return DeckPageListBloc(repository);
      },
      wait: Duration.zero,
      expect: () => <TypeMatcher<DeckPageListLoaded>>[
        isA<DeckPageListLoaded>()
            .having((DeckPageListLoaded s) => s.currentPageName,
                'currentPageName', 'Default page')
            .having((DeckPageListLoaded s) => s.pages.length, 'pages', 1),
      ],
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'AddPage: adds new unique page',
      build: () {
        when(() => repository.getDeckPageList()).thenAnswer(
          (_) async => ('Default page', <String>['Default page']),
        );
        when(() => repository.save(any(), any())).thenAnswer((_) async {});
        return DeckPageListBloc(repository);
      },
      act: (DeckPageListBloc bloc) async {
        await Future<void>.delayed(Duration.zero);
        bloc.add(DeckPageListAddPage());
      },
      wait: const Duration(milliseconds: 10),
      expect: () => <TypeMatcher<DeckPageListLoaded>>[
        isA<DeckPageListLoaded>(),
        isA<DeckPageListLoaded>()
            .having((DeckPageListLoaded s) => s.pages.length, 'pages.length', 2)
            .having(
                (DeckPageListLoaded s) => s.currentPageName, 'current', 'Page'),
      ],
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'SelectPage: switches current page',
      build: () {
        when(() => repository.getDeckPageList()).thenAnswer(
          (_) async => ('Default page', <String>['Default page', 'Page']),
        );
        when(() => repository.save(any(), any())).thenAnswer((_) async {});
        return DeckPageListBloc(repository);
      },
      act: (DeckPageListBloc bloc) async {
        await Future<void>.delayed(Duration.zero);
        bloc.add(const DeckPageListSelectPage('Page'));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => <TypeMatcher<DeckPageListLoaded>>[
        isA<DeckPageListLoaded>(),
        isA<DeckPageListLoaded>()
            .having((DeckPageListLoaded s) => s.currentPageName,
                'selected page', 'Page')
            .having((DeckPageListLoaded s) => s.isEditing, 'isEditing', false),
      ],
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'DeletePage: deletes current page and selects previous',
      build: () {
        when(() => repository.getDeckPageList()).thenAnswer(
          (_) async => ('Page', <String>['Default page', 'Page']),
        );
        when(() => repository.save(any(), any())).thenAnswer((_) async {});
        return DeckPageListBloc(repository);
      },
      act: (DeckPageListBloc bloc) async {
        await Future<void>.delayed(Duration.zero);
        bloc.add(DeckPageListDeletePage());
      },
      wait: const Duration(milliseconds: 10),
      expect: () => <TypeMatcher<DeckPageListLoaded>>[
        isA<DeckPageListLoaded>(),
        isA<DeckPageListLoaded>().having(
            (DeckPageListLoaded s) => s.pages, 'pages', <String>[
          'Default page'
        ]).having((DeckPageListLoaded s) => s.currentPageName,
            'currentPageName', 'Default page'),
      ],
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'StartEditing: enables editing mode',
      build: () {
        when(() => repository.getDeckPageList()).thenAnswer(
          (_) async => ('Default page', <String>['Default page']),
        );
        when(() => repository.save(any(), any())).thenAnswer((_) async {});
        return DeckPageListBloc(repository);
      },
      act: (DeckPageListBloc bloc) async {
        await Future<void>.delayed(Duration.zero);
        bloc.add(DeckPageListStartEditingPage());
      },
      wait: const Duration(milliseconds: 10),
      expect: () => <TypeMatcher<DeckPageListLoaded>>[
        isA<DeckPageListLoaded>(),
        isA<DeckPageListLoaded>()
            .having((DeckPageListLoaded s) => s.isEditing, 'isEditing', true),
      ],
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'StopEditing: renames page and disables editing',
      build: () {
        when(() => repository.getDeckPageList()).thenAnswer(
          (_) async => ('Default page', <String>['Default page']),
        );
        when(() => repository.save(any(), any())).thenAnswer((_) async {});
        return DeckPageListBloc(repository);
      },
      act: (DeckPageListBloc bloc) async {
        await Future<void>.delayed(Duration.zero);
        bloc.add(const DeckPageListStopEditingPage('Renamed'));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => <TypeMatcher<DeckPageListLoaded>>[
        isA<DeckPageListLoaded>(),
        isA<DeckPageListLoaded>()
            .having(
                (DeckPageListLoaded s) => s.pages, 'pages', <String>['Renamed'])
            .having((DeckPageListLoaded s) => s.currentPageName, 'current',
                'Renamed')
            .having((DeckPageListLoaded s) => s.isEditing, 'isEditing', false),
      ],
    );

    blocTest<DeckPageListBloc, DeckPageListState>(
      'Reorder: moves page in list',
      build: () {
        when(() => repository.getDeckPageList()).thenAnswer(
          (_) async =>
              ('Default page', <String>['Default page', 'Page', 'Page 1']),
        );
        when(() => repository.save(any(), any())).thenAnswer((_) async {});
        return DeckPageListBloc(repository);
      },
      act: (DeckPageListBloc bloc) async {
        bloc.add(DeckPageListInit());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const DeckPageListReorder(0, 2));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => <TypeMatcher<DeckPageListLoaded>>[
        isA<DeckPageListLoaded>(),
        isA<DeckPageListLoaded>().having((DeckPageListLoaded s) => s.pages,
            'pages', <String>['Page', 'Default page', 'Page 1']),
      ],
    );
  });
}
