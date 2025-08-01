import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:obs_websocket/request.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/set_active_scene_action.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/set_active_scene_form.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:obs_websocket/obs_websocket.dart';

class MockObsService extends Mock implements ObsService {}

class MockObsWebSocket extends Mock implements ObsWebSocket {}

class MockScenes extends Mock implements Scenes {}

class FakeScene extends Fake implements Scene {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeScene());
  });

  setUp(() {
    sl.reset();
  });

  group('SetActiveSceneAction', () {
    test('label returns default name if sceneName is empty', () {
      final action = SetActiveSceneAction();
      expect(action.label, equals('OBS | Set Active Scene'));
    });

    test('label includes sceneName if not empty', () {
      final action = SetActiveSceneAction(sceneName: 'Main');
      expect(action.label, equals('OBS | Set Active Scene (Main)'));
    });

    test('toJson/fromJson works correctly', () {
      final original = SetActiveSceneAction(sceneName: 'Main');
      final json = original.toJson();
      final from = SetActiveSceneAction.fromJson(json);
      expect(from.sceneName, equals(original.sceneName));
      expect(from.type, equals(original.type));
    });

    test('copy returns new instance with same sceneName but different id', () {
      final action = SetActiveSceneAction(sceneName: 'Scene1');
      final copied = action.copy() as SetActiveSceneAction;

      expect(copied.sceneName, equals(action.sceneName));
      expect(copied.id, isNot(equals(action.id)));
    });

    testWidgets('form calls onUpdated with new scene name', (tester) async {
      final mockObs = MockObsWebSocket();
      final mockObsService = MockObsService();
      final mockScenes = MockScenes();

      when(() => mockObsService.obs).thenReturn(mockObs);
      when(() => mockObs.scenes).thenReturn(mockScenes);
      when(() => mockScenes.getSceneList()).thenAnswer(
        (_) async => SceneListResponse(
          currentProgramSceneName: 'Old Scene',
          scenes: [
            Scene(sceneName: 'Old Scene', sceneIndex: 0),
            Scene(sceneName: 'New Scene', sceneIndex: 1),
          ],
        ),
      );

      sl.registerSingleton<ObsService>(mockObsService);

      SetActiveSceneAction? updated;

      final action = SetActiveSceneAction(sceneName: 'Old Scene');

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) {
            return Scaffold(
              body: action.form(
                context,
                onUpdated: (a) => updated = a as SetActiveSceneAction,
              ),
            );
          }),
        ),
      );

      await tester.pumpAndSettle();

      final formFinder = find.byType(SetActiveSceneForm);
      expect(formFinder, findsOneWidget);
      final formWidget = tester.widget<SetActiveSceneForm>(formFinder);

      formWidget.onSceneChanged!(
        Scene(sceneName: 'New Scene', sceneIndex: 1),
      );

      expect(updated, isNotNull);
      expect(updated!.sceneName, equals('New Scene'));
    });

    test('execute calls OBS service with correct scene', () async {
      final mockObsService = MockObsService();
      final mockObs = MockObsWebSocket();
      final mockScenes = MockScenes();

      when(() => mockObsService.obs).thenReturn(mockObs);
      when(() => mockObs.scenes).thenReturn(mockScenes);
      when(() => mockScenes.setCurrentProgramScene('Scene A'))
          .thenAnswer((_) async {});

      sl.registerSingleton<ObsService>(mockObsService);

      final action = SetActiveSceneAction(sceneName: 'Scene A');

      await action.execute();

      verify(() => mockScenes.setCurrentProgramScene('Scene A')).called(1);
    });

    test('execute does nothing if sceneName is empty', () async {
      final mockObsService = MockObsService();
      sl.registerSingleton<ObsService>(mockObsService);

      final action = SetActiveSceneAction(sceneName: '');

      await action.execute();

      verifyNever(() => mockObsService.obs);
    });
  });
}
