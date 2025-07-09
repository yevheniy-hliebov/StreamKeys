import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:streamkeys/desktop/utils/process_runner.dart';
import 'package:streamkeys/service_locator.dart';

import 'hidmacros_service_test.mocks.dart';

class TestHidMacrosService extends HidMacrosService {
  TestHidMacrosService(super.runner);

  @override
  File? getNircmdFileOrNull() {
    return File('dummy');
  }
}

@GenerateMocks([Process, ProcessRunner])
void main() {
  late TestHidMacrosService service;
  late MockProcessRunner mockRunner;

  setUp(() {
    mockRunner = MockProcessRunner();
    service = TestHidMacrosService(mockRunner);
  });

  group('HidMacrosService', () {
    test('isRunning returns true when process found', () async {
      when(mockRunner.run(any, any))
          .thenAnswer((_) async => ProcessResult(0, 0, 'hidmacros.exe', ''));
      final result = await service.isRunning();
      expect(result, true);
    });

    test('isRunning returns false when hidmacros.exe not found', () async {
      when(mockRunner.run(any, any)).thenAnswer(
        (_) async => ProcessResult(0, 0, 'otherprocess.exe', ''),
      );
      expect(await service.isRunning(), false);
    });

    test('start calls processRunner.start and logs', () async {
      final mockProcess = MockProcess();
      when(mockRunner.start(any, any, mode: anyNamed('mode')))
          .thenAnswer((_) async => mockProcess);
      when(mockProcess.pid).thenReturn(123);

      await service.start();

      verify(mockRunner.start(any, any, mode: anyNamed('mode'))).called(1);
    });

    test('stop calls processRunner.run', () async {
      when(mockRunner.run(any, any)).thenAnswer(
        (_) async => ProcessResult(0, 0, '', ''),
      );

      await service.stop();

      verify(mockRunner.run(any, any)).called(1);
    });

    test('restart calls stop and start with delay', () async {
      final mockProcess = MockProcess();
      when(mockRunner.start(any, any, mode: anyNamed('mode')))
          .thenAnswer((_) async => mockProcess);
      when(mockProcess.pid).thenReturn(123);
      when(mockRunner.run(any, any)).thenAnswer(
        (_) async => ProcessResult(0, 0, '', ''),
      );

      await service.restart(waitDuration: const Duration(milliseconds: 10));

      verify(mockRunner.run(any, any)).called(1);
      verify(mockRunner.start(any, any, mode: anyNamed('mode'))).called(1);
    });
  });
}
