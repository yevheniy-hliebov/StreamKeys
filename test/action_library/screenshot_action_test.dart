import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:obs_websocket/request.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/screenshot_action.dart';
import 'package:streamkeys/desktop/utils/file_manager.dart';
import 'package:streamkeys/desktop/utils/sound_service.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:obs_websocket/obs_websocket.dart';

import 'screenshot_action_test.mocks.dart';

@GenerateMocks([
  ObsService,
  ObsWebSocket,
  Scenes,
  Sources,
  SoundService,
  FileManager,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockObsService mockObsService;
  late MockObsWebSocket mockObs;
  late MockScenes mockScenes;
  late MockSources mockSources;
  late MockSoundService mockSoundService;
  late MockFileManager mockFileManager;

  const fallbackDuration = Duration.zero;
  const fallbackBool = false;

  setUp(() {
    mockObsService = MockObsService();
    mockObs = MockObsWebSocket();
    mockScenes = MockScenes();
    mockSources = MockSources();
    mockSoundService = MockSoundService();
    mockFileManager = MockFileManager();

    sl.reset();
  });

  group('ScreenshotAction', () {
    test('label returns default if delay is zero', () {
      final action = ScreenshotAction(
        delay: Duration.zero,
        soundService: mockSoundService,
        fileManager: mockFileManager,
      );
      expect(action.label, 'OBS | Screenshot');
    });

    test('label returns with delay if delay > zero', () {
      final action = ScreenshotAction(
        delay: const Duration(milliseconds: 1500),
        soundService: mockSoundService,
        fileManager: mockFileManager,
      );
      expect(action.label, 'OBS | Screenshot (delay: 1.50s)');
    });

    test('toJson and fromJson', () {
      final action = ScreenshotAction(
        recordingPath: 'C:/Test',
        delay: const Duration(seconds: 3),
        playSound: true,
        soundService: mockSoundService,
        fileManager: mockFileManager,
      );
      final json = action.toJson();
      final from = ScreenshotAction.fromJson(
        json,
        soundService: mockSoundService,
        fileManager: mockFileManager,
      );

      expect(from.recordingPath, action.recordingPath);
      expect(from.delay, action.delay);
      expect(from.playSound, action.playSound);
    });

    test('copy returns new instance with same values but different id', () {
      final action = ScreenshotAction(
        recordingPath: 'C:/Test',
        delay: const Duration(seconds: 2),
        playSound: true,
        soundService: mockSoundService,
        fileManager: mockFileManager,
      );
      final copy = action.copy() as ScreenshotAction;

      expect(copy.recordingPath, action.recordingPath);
      expect(copy.delay, action.delay);
      expect(copy.playSound, action.playSound);
      expect(copy.id, isNot(action.id));
    });

    test('execute performs screenshot and sound flow', () async {
      when(mockObsService.obs).thenReturn(mockObs);
      when(mockObs.scenes).thenReturn(mockScenes);
      when(mockObs.sources).thenReturn(mockSources);

      when(mockScenes.getCurrentProgramScene())
          .thenAnswer((_) async => 'Scene1');

      when(mockSources.getSourceScreenshot(any))
          .thenAnswer((_) async => SourceScreenshotResponse(
                imageData: 'data:image/jpeg;base64,aGVsbG8=',
              ));

      when(mockFileManager.decodeBase64Image('aGVsbG8='))
          .thenReturn(Uint8List.fromList([1, 2, 3]));

      when(mockFileManager.saveScreenshot(
        bytes: anyNamed('bytes'),
        fileNamePart: anyNamed('fileNamePart'),
      )).thenAnswer((_) async => '');

      when(mockSoundService.countdownTick(fallbackDuration,
              playSound: fallbackBool))
          .thenAnswer((_) async {});
      when(mockSoundService.playShutter()).thenAnswer((_) async {});

      sl.registerSingleton<ObsService>(mockObsService);

      final action = ScreenshotAction(
        delay: const Duration(seconds: 1),
        playSound: true,
        soundService: mockSoundService,
        fileManager: mockFileManager,
      );

      await action.execute();

      verify(mockSoundService.countdownTick(const Duration(seconds: 1),
              playSound: true))
          .called(1);
      verify(mockScenes.getCurrentProgramScene()).called(1);
      verify(mockSources.getSourceScreenshot(any)).called(1);
      verify(mockFileManager.decodeBase64Image('aGVsbG8=')).called(1);
      verify(mockFileManager.saveScreenshot(
              bytes: Uint8List.fromList([1, 2, 3]), fileNamePart: 'Scene1'))
          .called(1);
      verify(mockSoundService.playShutter()).called(1);
    });

    test('execute returns immediately if obs is null', () async {
      when(mockObsService.obs).thenReturn(null);
      sl.registerSingleton<ObsService>(mockObsService);

      final action = ScreenshotAction(
        soundService: mockSoundService,
        fileManager: mockFileManager,
      );
      await action.execute();

      verify(mockObsService.obs).called(1);
    });

    test('execute catches exceptions and prints in debug mode', () async {
      when(mockObsService.obs).thenReturn(mockObs);
      when(mockObs.scenes).thenThrow(Exception('fail'));

      when(mockSoundService.countdownTick(fallbackDuration,
              playSound: fallbackBool))
          .thenAnswer((_) async {});

      sl.registerSingleton<ObsService>(mockObsService);

      final action = ScreenshotAction(
        soundService: mockSoundService,
        fileManager: mockFileManager,
      );

      final printLogs = <String>[];
      final spec = ZoneSpecification(
        print: (self, parent, zone, line) {
          printLogs.add(line);
        },
      );

      await Zone.current.fork(specification: spec).run(() async {
        await action.execute();
      });

      expect(
        printLogs.any((line) => line.contains('Exception: fail')),
        true,
      );
    });
  });
}
