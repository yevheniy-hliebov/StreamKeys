import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/utils/launch_file_or_app_service.dart';
import 'package:streamkeys/desktop/utils/process_runner.dart';

import 'launch_file_or_app_service_test.mocks.dart';

@GenerateMocks([Process, ProcessRunner])
void main() {
  late LaunchFileOrAppService service;
  late MockProcessRunner mockRunner;
  final mockProcess = MockProcess();

  setUp(() {
    mockRunner = MockProcessRunner();
    service = LaunchFileOrAppService(mockRunner);
  });

  group('LaunchFileOrAppService', () {
    test('throws if file does not exist', () async {
      const fakePath = 'nonexistent.exe';
      expect(() => service.launch(fakePath), throwsException);
    });

    test('launches .vbs file', () async {
      final file = File('test_script.vbs');
      await file.writeAsString('// fake vbs');
      final dir = file.parent.path;
      final fileName = file.uri.pathSegments.last;

      when(mockRunner.start(
        'powershell',
        ['-Command', 'Set-Location -Path "$dir"; wscript "$fileName"'],
        runInShell: true,
      )).thenAnswer((_) async => mockProcess);

      await service.launch(file.path);

      verify(mockRunner.start(
        'powershell',
        ['-Command', 'Set-Location -Path "$dir"; wscript "$fileName"'],
        runInShell: true,
      )).called(1);

      file.deleteSync();
    });

    test('launches .bat file (without admin)', () async {
      final file = File('test_script.bat');
      await file.writeAsString('echo hello');
      final dir = file.parent.path;
      final fileName = file.uri.pathSegments.last;

      final command = 'Set-Location -Path "$dir"; .\\$fileName "arg1" "arg2"';

      when(mockRunner.start(
        'powershell',
        ['-Command', command],
        runInShell: true,
      )).thenAnswer((_) async => mockProcess);

      await service.launch(file.path, arguments: ['arg1', 'arg2']);

      verify(mockRunner.start(
        'powershell',
        ['-Command', command],
        runInShell: true,
      )).called(1);

      file.deleteSync();
    });

    test('launches .bat file (with admin)', () async {
      final file = File('admin_script.bat');
      await file.writeAsString('echo admin');

      when(mockRunner.start(
        'powershell',
        any,
        runInShell: true,
      )).thenAnswer((_) async => mockProcess);

      await service.launch(file.path, asAdmin: true);

      verify(mockRunner.start(
        'powershell',
        argThat(contains('-Command')),
        runInShell: true,
      )).called(1);

      file.deleteSync();
    });

    test('launches .exe file with admin', () async {
      final file = File('fake_app.exe');
      await file.writeAsString('');
      final dir = file.parent.path;

      when(mockRunner.start(
        'powershell',
        [
          'Start-Process',
          '-FilePath',
          '"${file.path}"',
          '-WorkingDirectory',
          '"$dir"',
          '-Verb',
          'RunAs',
        ],
        runInShell: true,
      )).thenAnswer((_) async => mockProcess);

      await service.launch(file.path, asAdmin: true);

      verify(mockRunner.start(
        'powershell',
        [
          'Start-Process',
          '-FilePath',
          '"${file.path}"',
          '-WorkingDirectory',
          '"$dir"',
          '-Verb',
          'RunAs',
        ],
        runInShell: true,
      )).called(1);

      file.deleteSync();
    });
  });
}
