import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/streamerbot/do_action.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/streamerbot_doaction_form.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/do_action_response.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_action.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_web_socket.dart';
import 'package:streamkeys/service_locator.dart';

import 'streamerbot_do_action_test.mocks.dart';

@GenerateMocks([StreamerBotWebSocket, StreamerBotService, BindingActionIcons])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockStreamerBotWebSocket mockWebSocket;
  late MockStreamerBotService mockService;

  const fakeAction = StreamerBotAction(
    id: 'abc123',
    name: 'Shoutout',
    group: 'General',
    enabled: true,
    subactionCount: 3,
  );

  final fakeResponse = DoActionResponse(id: 'fakeid', status: 'ok');

  setUp(() {
    mockWebSocket = MockStreamerBotWebSocket();
    mockService = MockStreamerBotService();

    when(mockService.webSocket).thenReturn(mockWebSocket);
    sl.registerSingleton<StreamerBotService>(mockService);
  });

  tearDown(() {
    sl.reset();
  });

  group('StreamerBotDoAction', () {
    test('label returns fallback text if action is null', () {
      final action = StreamerBotDoAction();
      expect(action.label, 'Streamer.bot | Do Action');
    });

    test('label returns action name if action is set', () {
      final action = StreamerBotDoAction(action: fakeAction);
      expect(action.label, 'Streamer.bot | Do Action (Shoutout)');
    });

    test('toJson and fromJson preserve data', () {
      final original = StreamerBotDoAction(action: fakeAction);
      final json = original.toJson();
      final restored = StreamerBotDoAction.fromJson(json);

      expect(restored.action!.id, fakeAction.id);
      expect(restored.action!.name, fakeAction.name);
    });

    test('copy returns new instance with same action', () {
      final action = StreamerBotDoAction(action: fakeAction);
      final copied = action.copy() as StreamerBotDoAction;

      expect(copied.action, action.action);
      expect(copied == action, false); // різні інстанси
    });

    test('execute calls webSocket.doAction with correct parameters', () async {
      final action = StreamerBotDoAction(action: fakeAction);

      when(mockWebSocket.doAction(id: anyNamed('id'), name: anyNamed('name')))
          .thenAnswer((_) async => fakeResponse);

      await action.execute();

      verify(mockWebSocket.doAction(id: fakeAction.id, name: 'Do Action'))
          .called(1);
    });

    testWidgets('form returns correct widget', (tester) async {
      final action = StreamerBotDoAction(action: fakeAction);
      final widget = action.form(tester.element(find.byType(Container)));

      expect(widget, isA<StreamerBotDoactionForm>());
    });
  });
}
