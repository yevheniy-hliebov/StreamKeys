import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/desktop/features/streamerbot/bloc/connection/streamerbot_connection_bloc.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_service.dart';

import 'streamerbot_connection_bloc_test.mocks.dart';

@GenerateMocks([StreamerBotService])
void main() {
  late MockStreamerBotService mockService;
  late StreamerBotConnectionBloc bloc;

  setUp(() {
    mockService = MockStreamerBotService();
  });

  group('StreamerBotConnectionBloc', () {
    test('initial state is StreamerBotConnectionState.initial()', () {
      when(mockService.connectionStream)
          .thenAnswer((_) => const Stream<ConnectionStatus>.empty());

      bloc = StreamerBotConnectionBloc(mockService);

      expect(bloc.state.status, ConnectionStatus.notConnected);
    });

    test('emits new state when StreamerBotConnectionChanged is added', () {
      when(mockService.connectionStream)
          .thenAnswer((_) => const Stream<ConnectionStatus>.empty());

      bloc = StreamerBotConnectionBloc(mockService);

      const expectedStatus = ConnectionStatus.connected;

      bloc.add(const StreamerBotConnectionChanged(expectedStatus));

      expectLater(
        bloc.stream,
        emitsInOrder(const [
          StreamerBotConnectionState(expectedStatus),
        ]),
      );
    });

    test('listens to streamerBot.connectionStream and emits states', () async {
      final controller = StreamController<ConnectionStatus>();
      when(mockService.connectionStream).thenAnswer((_) => controller.stream);

      bloc = StreamerBotConnectionBloc(mockService);

      final statuses = [
        ConnectionStatus.connecting,
        ConnectionStatus.connected,
        ConnectionStatus.notConnected,
      ];

      expectLater(
        bloc.stream,
        emitsInOrder(const [
          StreamerBotConnectionState(ConnectionStatus.connecting),
          StreamerBotConnectionState(ConnectionStatus.connected),
          StreamerBotConnectionState(ConnectionStatus.notConnected),
        ]),
      );

      for (final status in statuses) {
        controller.add(status);
        await Future.delayed(Duration.zero);
      }

      await controller.close();
    });
  });
}
