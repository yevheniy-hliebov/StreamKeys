import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/website_action.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/key_bindings/bloc/key_bindings_bloc.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/repositorires/key_bindings_repository.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_key_data.dart';

class MockRepository extends Mock implements KeyBindingsRepository {}

class MockDeckBloc extends Mock implements DeckPageListBloc {}

void main() {
  late MockRepository repository;
  late MockDeckBloc deckBloc;
  late StreamController<DeckPageListState> deckStreamController;

  const mockKeyData = GridKeyData(
    keyCode: 1,
    name: '1',
  );
  final mockCustomBindingData = KeyBindingData.create(
    id: 'uuid-custom',
    name: 'custom binding',
  );

  final mockAction = WebsiteAction(
    id: 'fixed-id',
  );

  final updatedMockAction = WebsiteAction(
    id: mockAction.id,
    url: 'https://updated.com',
  );

  final mockPage1Map = {
    '1': KeyBindingData.create(id: 'uuid1', name: 'page1 button1'),
    '2': KeyBindingData.create(id: 'uuid2', name: 'page1 button2'),
  };
  final mockPage2Map = {
    '1': KeyBindingData.create(id: 'uuid3', name: 'page2 button1'),
    '2': KeyBindingData.create(id: 'uuid4', name: 'page2 button2'),
  };
  final KeyBindingPagesMap mockMap = {
    'page1': mockPage1Map,
    'page2': mockPage2Map,
  };

  setUpAll(() {
    registerFallbackValue(mockCustomBindingData);
  });

  KeyBindingPagesMap deepCopyKeyMap(KeyBindingPagesMap original) {
    return original.map(
      (pageId, keys) => MapEntry(
        pageId,
        Map<String, KeyBindingData>.from(keys),
      ),
    );
  }

  setUp(() {
    repository = MockRepository();
    deckBloc = MockDeckBloc();

    deckStreamController = StreamController<DeckPageListState>();

    when(() => deckBloc.stream).thenAnswer((_) => deckStreamController.stream);
    when(() => deckBloc.state).thenReturn(DeckPageListInitial());

    when(() => deckBloc.stream).thenAnswer(
      (_) => const Stream<DeckPageListState>.empty(),
    );

    when(() => repository.getKeyMap()).thenAnswer((invocation) async {
      return (
        'page1',
        deepCopyKeyMap(mockMap),
      );
    });
    when(() => repository.saveKeyBindingDataOnPage(any(), any(), any()))
        .thenAnswer(
      (invocation) async {},
    );
  });

  group('KeyBindingsBloc', () {
    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'emits KeyBindingsLoaded after init',
      build: () {
        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) => bloc.add(KeyBindingsInit()),
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          map: mockPage1Map,
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
      ],
    );

    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'emits KeyBindingsLoaded when DeckPageListLoaded is received after init',
      build: () {
        deckStreamController = StreamController<DeckPageListState>();

        when(() => deckBloc.stream)
            .thenAnswer((_) => deckStreamController.stream);
        when(() => deckBloc.state).thenReturn(DeckPageListInitial());

        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) async {
        bloc.add(KeyBindingsInit());
        await Future.delayed(const Duration(milliseconds: 20));
        deckStreamController.add(
          const DeckPageListLoaded(
            pages: [],
            currentPageId: 'page2',
          ),
        );
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          map: mockPage1Map,
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
        KeyBindingsLoaded(
          map: mockPage2Map,
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
      ],
      tearDown: () {
        deckStreamController.close();
      },
    );

    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'does not emit state after close (subscription is cancelled)',
      build: () {
        deckStreamController = StreamController<DeckPageListState>();

        when(() => deckBloc.stream)
            .thenAnswer((_) => deckStreamController.stream);
        when(() => deckBloc.state).thenReturn(DeckPageListInitial());

        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) async {
        bloc.add(KeyBindingsInit());

        await Future.delayed(const Duration(milliseconds: 20));

        await bloc.close();

        deckStreamController.add(
          const DeckPageListLoaded(
            pages: [],
            currentPageId: 'page2',
          ),
        );

        await Future.delayed(const Duration(milliseconds: 20));
      },
      expect: () => [
        KeyBindingsLoaded(
          map: mockPage1Map,
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
      ],
      tearDown: () {
        deckStreamController.close();
      },
    );

    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'emits KeyBindingsPageChanged',
      build: () {
        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) async {
        bloc.add(KeyBindingsInit());
        await Future.delayed(const Duration(milliseconds: 20));
        bloc.add(const KeyBindingsPageChanged('page2'));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          map: mockPage1Map,
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
        KeyBindingsLoaded(
          map: mockPage2Map,
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
      ],
    );

    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'emits KeyBindingsSelectKey',
      build: () {
        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) async {
        bloc.add(KeyBindingsInit());
        await Future.delayed(const Duration(milliseconds: 20));
        bloc.add(const KeyBindingsSelectKey(mockKeyData));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          map: mockPage1Map,
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
        KeyBindingsLoaded(
          map: mockPage1Map,
          currentKeyData: mockKeyData,
          currentKeyBindingData:
              KeyBindingData.create(id: 'uuid1', name: 'page1 button1'),
        ),
      ],
    );

    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'emits KeyBindingsSaveDataOnPage',
      build: () {
        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) async {
        bloc.add(KeyBindingsInit());
        await Future.delayed(const Duration(milliseconds: 20));
        bloc.add(KeyBindingsSaveDataOnPage(
          keyCode: 1,
          keyBindingData: mockCustomBindingData,
        ));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          map: {
            '1': mockCustomBindingData,
            '2': KeyBindingData.create(id: 'uuid2', name: 'page1 button2'),
          },
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
      ],
      skip: 1,
      verify: (_) {
        verify(() {
          return repository.saveKeyBindingDataOnPage(
              'page1', 1, mockCustomBindingData);
        }).called(1);
      },
    );

    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'emits KeyBindingsAddAction',
      build: () {
        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) async {
        bloc.add(KeyBindingsInit());
        await Future.delayed(const Duration(milliseconds: 20));
        bloc.add(KeyBindingsAddAction(
          keyCode: 2,
          action: mockAction,
        ));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          map: {
            '1': mockPage1Map['1']!,
            '2': KeyBindingData.create(
                id: 'uuid2', name: 'page1 button2', actions: [mockAction]),
          },
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
      ],
      skip: 1,
      verify: (_) {
        verify(() {
          return repository.saveKeyBindingDataOnPage(
            'page1',
            2,
            KeyBindingData.create(
              id: 'uuid2',
              name: 'page1 button2',
              actions: [mockAction],
            ),
          );
        }).called(1);
      },
    );

    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'emits KeyBindingsLoaded when updating an action',
      build: () {
        final page1Map = Map<String, KeyBindingData>.from(mockPage1Map);
        page1Map['2'] = KeyBindingData.create(
          id: 'uuid2',
          name: 'page1 button2',
          actions: [mockAction],
        );

        when(() => repository.getKeyMap()).thenAnswer((_) async {
          return ('page1', {'page1': page1Map, 'page2': mockPage2Map});
        });

        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) async {
        bloc.add(KeyBindingsInit());
        await Future.delayed(const Duration(milliseconds: 20));
        bloc.add(KeyBindingsUpdateAction(
          keyCode: 2,
          index: 0,
          updatedAction: updatedMockAction,
        ));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          map: {
            '1': mockPage1Map['1']!,
            '2': KeyBindingData.create(
              id: 'uuid2',
              name: 'page1 button2',
              actions: [updatedMockAction],
            ),
          },
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
      ],
      skip: 1,
      verify: (_) {
        verify(() {
          return repository.saveKeyBindingDataOnPage(
            'page1',
            2,
            KeyBindingData.create(
              id: 'uuid2',
              name: 'page1 button2',
              actions: [updatedMockAction],
            ),
          );
        }).called(1);
      },
    );

    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'emits KeyBindingsLoaded when deleting an action',
      build: () {
        final action = WebsiteAction();
        final page1Map = Map<String, KeyBindingData>.from(mockPage1Map);
        page1Map['2'] = KeyBindingData.create(
          id: 'uuid2',
          name: 'page1 button2',
          actions: [action],
        );

        when(() => repository.getKeyMap()).thenAnswer((_) async {
          return ('page1', {'page1': page1Map, 'page2': mockPage2Map});
        });

        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) async {
        bloc.add(KeyBindingsInit());
        await Future.delayed(const Duration(milliseconds: 20));
        bloc.add(const KeyBindingsDeleteAction(
          keyCode: 2,
          index: 0,
        ));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          map: {
            '1': mockPage1Map['1']!,
            '2': KeyBindingData.create(id: 'uuid2', name: 'page1 button2'),
          },
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
      ],
      skip: 1,
      verify: (_) {
        verify(() {
          return repository.saveKeyBindingDataOnPage(
            'page1',
            2,
            KeyBindingData.create(id: 'uuid2', name: 'page1 button2'),
          );
        }).called(1);
      },
    );

    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'emits KeyBindingsLoaded when reordering actions',
      build: () {
        final action1 = WebsiteAction(id: 'a1', url: '1');
        final action2 = WebsiteAction(id: 'a2', url: '2');
        final action3 = WebsiteAction(id: 'a3', url: '3');

        final page1Map = Map<String, KeyBindingData>.from(mockPage1Map);
        page1Map['2'] = KeyBindingData.create(
          id: 'uuid2',
          name: 'page1 button2',
          actions: [action1, action2, action3],
        );

        when(() => repository.getKeyMap()).thenAnswer((_) async {
          return ('page1', {'page1': page1Map, 'page2': mockPage2Map});
        });

        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) async {
        bloc.add(KeyBindingsInit());
        await Future.delayed(const Duration(milliseconds: 20));
        bloc.add(const KeyBindingsReorderActions(
          keyCode: 2,
          oldIndex: 0,
          newIndex: 2,
        ));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          map: {
            '1': mockPage1Map['1']!,
            '2': KeyBindingData.create(
              id: 'uuid2',
              name: 'page1 button2',
              actions: [
                WebsiteAction(id: 'a2', url: '2'),
                WebsiteAction(id: 'a1', url: '1'),
                WebsiteAction(id: 'a3', url: '3'),
              ],
            ),
          },
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
      ],
      skip: 1,
      verify: (_) {
        verify(() {
          return repository.saveKeyBindingDataOnPage(
            'page1',
            2,
            KeyBindingData.create(
              id: 'uuid2',
              name: 'page1 button2',
              actions: [
                WebsiteAction(id: 'a2', url: '2'),
                WebsiteAction(id: 'a1', url: '1'),
                WebsiteAction(id: 'a3', url: '3'),
              ],
            ),
          );
        }).called(1);
      },
    );

    blocTest<KeyBindingsBloc, KeyBindingsState>(
      'emits KeyBindingsSwapKeys',
      build: () {
        return KeyBindingsBloc(repository, deckBloc);
      },
      act: (bloc) async {
        bloc.add(KeyBindingsInit());
        await Future.delayed(const Duration(milliseconds: 20));
        bloc.add(const KeyBindingsSwapKeys(1, 2));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          map: {
            '1': KeyBindingData.create(id: 'uuid2', name: 'page1 button2'),
            '2': KeyBindingData.create(id: 'uuid1', name: 'page1 button1'),
          },
          currentKeyData: null,
          currentKeyBindingData: null,
        ),
      ],
      skip: 1,
    );
  });
}
