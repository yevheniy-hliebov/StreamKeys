import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/hidmacros_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/repositories/hidmacros_repository.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_service.dart';

class MockHidMacrosRepository extends Mock implements HidMacrosRepository {}

class MockHidMacrosService extends Mock implements HidMacrosService {}

class FakeKeyboardDevice extends Fake implements KeyboardDevice {}

void main() {
  late HidMacrosRepository repository;
  late HidMacrosService hidmacrosService;
  late HidMacrosBloc bloc;

  const keyboard1 = KeyboardDevice('Keyboard1', 'id1');
  const keyboard2 = KeyboardDevice('Keyboard2', 'id2');

  setUp(() {
    registerFallbackValue(FakeKeyboardDevice());
    registerFallbackValue(KeyboardType.numpad);

    repository = MockHidMacrosRepository();
    hidmacrosService = MockHidMacrosService();

    when(() => repository.getDeviceList()).thenReturn([keyboard1, keyboard2]);
    when(() => repository.getSelectedKeyboard()).thenReturn(keyboard1);
    when(
      () => repository.getSelectedKeyboardType(),
    ).thenReturn(KeyboardType.full);
    when(() => repository.getAutoStart()).thenReturn(true);
    when(() => repository.init()).thenAnswer((_) async => {});
    when(() => repository.saveAutoStart(any())).thenAnswer((_) async => {});
    when(() => repository.setMinimizeToTray(any())).thenAnswer((_) async => {});
    when(() => repository.setStartMinimized(any())).thenAnswer((_) async => {});
    when(
      () => repository.select(
        keyboard: any(named: 'keyboard'),
        type: any(named: 'type'),
      ),
    ).thenAnswer((_) async => {});

    when(
      () => hidmacrosService.restart(
        autoStart: any(named: 'autoStart'),
        onBetween: any(named: 'onBetween'),
      ),
    ).thenAnswer((invocation) async {
      await invocation.namedArguments[#onBetween]?.call();
    });

    when(() => repository.getMinimizeToTray()).thenReturn(false);
    when(() => repository.getStartMinimized()).thenReturn(false);

    bloc = HidMacrosBloc(repository: repository, hidmacros: hidmacrosService);
  });

  group('HidMacrosBloc', () {
    test('initial state is HidMacrosInitial', () {
      expect(bloc.state, HidMacrosInitial());
    });

    blocTest<HidMacrosBloc, HidMacrosState>(
      'emits loading and loaded states on HidMacrosLoadEvent',
      build: () => bloc,
      act: (bloc) => bloc.add(HidMacrosLoadEvent()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<HidMacrosLoading>(),
        isA<HidMacrosLoaded>().having(
          (s) => s.keyboards.length,
          'keyboards length',
          2,
        ),
      ],
      verify: (_) {
        verify(() => repository.init()).called(1);
        verify(() => repository.getDeviceList()).called(1);
        verify(() => repository.getSelectedKeyboard()).called(1);
        verify(() => repository.getSelectedKeyboardType()).called(1);
        verify(() => repository.getAutoStart()).called(1);
        verify(() => repository.getMinimizeToTray()).called(1);
        verify(() => repository.getStartMinimized()).called(1);
      },
    );

    blocTest<HidMacrosBloc, HidMacrosState>(
      'handles HidMacrosToggleAutoStartEvent and calls saveAutoStart',
      build: () => bloc,
      act: (bloc) => bloc.add(const HidMacrosToggleAutoStartEvent(false)),
      expect: () => [
        isA<HidMacrosLoaded>().having(
          (s) => s.hidmacrosConfig.autoStart,
          'autoStart',
          false,
        ),
      ],
      verify: (_) {
        verify(() => repository.saveAutoStart(false)).called(1);
      },
    );

    blocTest<HidMacrosBloc, HidMacrosState>(
      'handles HidMacrosToggleMinimizeToTrayEvent and calls setMinimizeToTray',
      build: () => bloc,
      act: (bloc) => bloc.add(const HidMacrosToggleMinimizeToTrayEvent(true)),
      expect: () => [
        isA<HidMacrosLoaded>().having(
          (s) => s.hidmacrosConfig.minimizeToTray,
          'minimizeToTray',
          true,
        ),
      ],
      verify: (_) {
        verify(() => repository.setMinimizeToTray(true)).called(1);
      },
    );

    blocTest<HidMacrosBloc, HidMacrosState>(
      'handles HidMacrosToggleStartMinizedEvent and calls setStartMinimized',
      build: () => bloc,
      act: (bloc) => bloc.add(const HidMacrosToggleStartMinizedEvent(true)),
      expect: () => [
        isA<HidMacrosLoaded>().having(
          (s) => s.hidmacrosConfig.startMinimized,
          'startMinimized',
          true,
        ),
      ],
      verify: (_) {
        verify(() => repository.setStartMinimized(true)).called(1);
      },
    );

    blocTest<HidMacrosBloc, HidMacrosState>(
      'handles HidMacrosSelectKeyboardEvent and calls repository.select',
      build: () => bloc,
      act: (bloc) => bloc.add(const HidMacrosSelectKeyboardEvent(keyboard2)),
      expect: () => [
        isA<HidMacrosLoading>(),
        isA<HidMacrosLoaded>().having(
          (s) => s.selectedKeyboard,
          'selectedKeyboard',
          keyboard2,
        ),
      ],
      verify: (_) {
        verify(
          () =>
              repository.select(keyboard: keyboard2, type: KeyboardType.numpad),
        ).called(1);
      },
    );

    blocTest<HidMacrosBloc, HidMacrosState>(
      'handles HidMacrosSelectKeyboardTypeEvent and calls repository.select',
      build: () {
        bloc.keyboards = [keyboard1];
        return bloc;
      },
      act: (bloc) {
        bloc.add(const HidMacrosSelectKeyboardTypeEvent(KeyboardType.compact));
      },
      expect: () => [
        isA<HidMacrosLoading>(),
        isA<HidMacrosLoaded>().having(
          (s) => s.selectedKeyboardType,
          'selectedKeyboardType',
          KeyboardType.compact,
        ),
      ],
      verify: (_) {
        verify(
          () => repository.select(
            keyboard: keyboard1,
            type: KeyboardType.compact,
          ),
        ).called(1);
      },
    );
  });
}
