import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
          mockPage1Map,
          null,
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
          mockPage1Map,
          null,
        ),
        KeyBindingsLoaded(
          mockPage2Map,
          null,
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
          mockPage1Map,
          null,
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
          mockPage1Map,
          null,
        ),
        KeyBindingsLoaded(
          mockPage2Map,
          null,
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
          mockPage1Map,
          null,
        ),
        KeyBindingsLoaded(
          mockPage1Map,
          mockKeyData,
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
        bloc.add(KeyBindingsSaveDataOnPage(1, mockCustomBindingData));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        KeyBindingsLoaded(
          {
            '1': mockCustomBindingData,
            '2': KeyBindingData.create(id: 'uuid2', name: 'page1 button2'),
          },
          null,
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
          {
            '1': KeyBindingData.create(id: 'uuid2', name: 'page1 button2'),
            '2': KeyBindingData.create(id: 'uuid1', name: 'page1 button1'),
          },
          null,
        ),
      ],
      skip: 1,
    );
  });
}
