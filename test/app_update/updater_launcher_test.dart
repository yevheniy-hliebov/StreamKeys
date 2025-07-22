import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:github_apk_updater/github_apk_updater.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/core/app_update/data/services/windows_updater_launcher.dart';
import 'package:streamkeys/desktop/utils/process_runner.dart';

import 'updater_launcher_test.mocks.dart';

class FakeProcess implements Process {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

@GenerateMocks([ProcessRunner])
void main() {
  late MockProcessRunner mockRunner;
  late bool exited;
  late WindowsUpdaterLauncher launcher;

  setUp(() {
    mockRunner = MockProcessRunner();
    exited = false;
    launcher = WindowsUpdaterLauncher(mockRunner, (_) => exited = true);
  });

  group('UpdaterLauncher', () {
    test('throws if Updater.exe does not exist', () async {
      final exePath =
          '${File(Platform.resolvedExecutable).parent.parent.path}/Updater.exe';
      final file = File(exePath);
      if (await file.exists()) await file.delete();

      expect(
        () => launcher.launch(mode: AppVersionMode.stable, version: 'v1.0.0'),
        throwsException,
      );
    });

    test('runs updater and exits', () async {
      final exePath =
          '${File(Platform.resolvedExecutable).parent.parent.path}/Updater.exe';
      final file = await File(exePath).create();

      when(mockRunner.start(any, any, mode: anyNamed('mode')))
          .thenAnswer((_) async => FakeProcess());

      await launcher.launch(mode: AppVersionMode.beta, version: 'v2.0.0');

      verify(mockRunner.start(
        argThat(contains('Updater.exe')),
        argThat(containsAll(['--mode', 'beta', '--version', 'v2.0.0'])),
        mode: ProcessStartMode.detached,
      )).called(1);

      expect(exited, isTrue);

      await file.delete();
    });
  });
}
