import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:obs_websocket/request.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/source_mute_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/action_state_enum.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/source_mute_action_form.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:obs_websocket/src/obs_websocket_base.dart';

class MockObsService extends Mock implements ObsService {}

class MockObsWebSocket extends Mock implements ObsWebSocket {}

class MockInputs extends Mock implements Inputs {}

void main() {
  setUp(() {
    sl.reset();
  });

  group('SourceMuteAction', () {
    test('label returns fallback if scene is empty', () {
      final action = SourceMuteAction();
      expect(action.label, equals('OBS | Source Mute'));
    });

    test('label returns full description if scene and source are set', () {
      final action = SourceMuteAction(
        sceneName: 'Main',
        sourceName: 'Mic/Aux',
        muteState: MuteState.mute,
      );
      expect(action.label,
          equals('OBS | Source Mute (Mute, Scene: Main, source: Mic/Aux)'));
    });

    test('toJson/fromJson works correctly', () {
      final original = SourceMuteAction(
        sceneName: 'Scene',
        sourceName: 'Mic',
        muteState: MuteState.notMuted,
      );
      final json = original.toJson();
      final from = SourceMuteAction.fromJson(json);

      expect(from.sceneName, equals(original.sceneName));
      expect(from.sourceName, equals(original.sourceName));
      expect(from.muteState, equals(original.muteState));
    });

    test('copy returns new instance with same values and different ID', () {
      final action = SourceMuteAction(
        sceneName: 'Scene',
        sourceName: 'Source',
        muteState: MuteState.mute,
      );
      final copy = action.copy() as SourceMuteAction;

      expect(copy.sceneName, equals(action.sceneName));
      expect(copy.sourceName, equals(action.sourceName));
      expect(copy.muteState, equals(action.muteState));
      expect(copy.id, isNot(equals(action.id)));
    });

    test('execute calls toggleInputMute when muteState is toggle', () async {
      final mockObs = MockObsWebSocket();
      final mockInputs = MockInputs();
      final mockService = MockObsService();

      when(() => mockObs.inputs).thenReturn(mockInputs);
      when(() => mockInputs.toggleInputMute(inputName: 'Mic'))
          .thenAnswer((_) async => true);
      when(() => mockService.obs).thenReturn(mockObs);

      sl.registerSingleton<ObsService>(mockService);

      final action = SourceMuteAction(
        sourceName: 'Mic',
        muteState: MuteState.toggle,
      );

      await action.execute();

      verify(() => mockInputs.toggleInputMute(inputName: 'Mic')).called(1);
    });

    test('execute calls setInputMute when muteState is mute', () async {
      final mockObs = MockObsWebSocket();
      final mockInputs = MockInputs();
      final mockService = MockObsService();

      when(() => mockObs.inputs).thenReturn(mockInputs);
      when(() => mockInputs.setInputMute(
            inputName: 'Mic',
            inputMuted: true,
          )).thenAnswer((_) async {});
      when(() => mockService.obs).thenReturn(mockObs);

      sl.registerSingleton<ObsService>(mockService);

      final action = SourceMuteAction(
        sourceName: 'Mic',
        muteState: MuteState.mute,
      );

      await action.execute();

      verify(() => mockInputs.setInputMute(inputName: 'Mic', inputMuted: true))
          .called(1);
    });

    test('execute does nothing if sourceName is empty', () async {
      final mockService = MockObsService();
      sl.registerSingleton<ObsService>(mockService);

      final action = SourceMuteAction(sourceName: '');

      await action.execute(); // should not crash or call anything

      verifyNever(() => mockService.obs);
    });

    testWidgets('form returns SourceMuteActionForm and calls onUpdated',
        (tester) async {
      final mockObs = MockObsWebSocket();
      final mockService = MockObsService();
      when(() => mockService.obs).thenReturn(mockObs);

      sl.registerSingleton<ObsService>(mockService);

      SourceMuteAction? updated;

      final action = SourceMuteAction(sceneName: 'A', sourceName: 'Mic');

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) {
            return Scaffold(
              body: action.form(
                context,
                onUpdated: (a) {
                  updated = a as SourceMuteAction;
                },
              ),
            );
          }),
        ),
      );

      final formFinder = find.byType(SourceMuteActionForm);
      expect(formFinder, findsOneWidget);

      expect(updated, isNotNull);
      expect(updated!.sceneName, equals(''));
    });
  });
}
