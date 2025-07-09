import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/launch_file_or_app_action.dart';
import 'package:streamkeys/service_locator.dart';

import 'launch_file_or_app_action_test.mocks.dart';

@GenerateMocks([LaunchFileOrAppService])
void main() {
  late MockLaunchFileOrAppService mockService;

  setUp(() {
    mockService = MockLaunchFileOrAppService();
    if (sl.isRegistered<LaunchFileOrAppService>()) {
      sl.unregister<LaunchFileOrAppService>();
    }
    sl.registerSingleton<LaunchFileOrAppService>(mockService);
  });

  group('LaunchFileOrAppAction', () {
    test('toJson and fromJson should be symmetric', () {
      final action = LaunchFileOrAppAction(
        filePath: 'C:/test.exe',
        launchAsAdmin: true,
      );

      final json = action.toJson();
      final from = LaunchFileOrAppAction.fromJson(json);

      expect(from.filePath, action.filePath);
      expect(from.launchAsAdmin, action.launchAsAdmin);
      expect(from.type, action.type);
    });

    test('label should include filePath and admin info', () {
      final action = LaunchFileOrAppAction(
        filePath: 'C:/app.exe',
        launchAsAdmin: true,
      );

      expect(action.label, 'Launch file or app (C:/app.exe, as admin)');
    });

    test('label fallback to name if path empty', () {
      final action = LaunchFileOrAppAction();
      expect(action.label, 'Launch file or app');
    });

    test('copy should return identical values', () {
      final action = LaunchFileOrAppAction(
        filePath: 'D:/tool.exe',
        launchAsAdmin: true,
      );

      final copy = action.copy() as LaunchFileOrAppAction;

      expect(copy.filePath, action.filePath);
      expect(copy.launchAsAdmin, action.launchAsAdmin);
      expect(copy.id != action.id, true);
    });

    test('execute should call LaunchFileOrAppService', () async {
      final action = LaunchFileOrAppAction(
        filePath: 'C:/launch.exe',
        launchAsAdmin: true,
      );

      when(mockService.launch('C:/launch.exe', asAdmin: true))
          .thenAnswer((_) async {});

      await action.execute();

      verify(mockService.launch('C:/launch.exe', asAdmin: true)).called(1);
    });

    test('execute should do nothing if path is empty', () async {
      final action = LaunchFileOrAppAction();

      await action.execute();

      verifyNever(mockService.launch('', asAdmin: false));
    });
  });
}
