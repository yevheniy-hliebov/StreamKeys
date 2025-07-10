import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/desktop/features/obs/bloc/connection/obs_connection_bloc.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_service.dart';

import 'obs_connection_bloc_test.mocks.dart';

@GenerateMocks([ObsService])
void main() {
  late MockObsService mockObsService;
  late ObsConnectionBloc bloc;

  setUp(() {
    mockObsService = MockObsService();
  });

  group('ObsConnectionBloc', () {
    test('initial state is ObsConnectionState.initial()', () {
      when(mockObsService.connectionStream)
          .thenAnswer((_) => const Stream<ConnectionStatus>.empty());

      bloc = ObsConnectionBloc(mockObsService);

      expect(bloc.state.status, ConnectionStatus.notConnected);
    });

    test('emits new state when ObsConnectionChanged event is added', () {
      when(mockObsService.connectionStream)
          .thenAnswer((_) => const Stream<ConnectionStatus>.empty());

      bloc = ObsConnectionBloc(mockObsService);

      const expectedStatus = ConnectionStatus.connected;

      bloc.add(const ObsConnectionChanged(expectedStatus));

      expectLater(
        bloc.stream,
        emitsInOrder(const [
          ObsConnectionState(expectedStatus),
        ]),
      );
    });

    test('listens to obs.connectionStream and emits states', () async {
      final controller = StreamController<ConnectionStatus>();
      when(mockObsService.connectionStream)
          .thenAnswer((_) => controller.stream);

      bloc = ObsConnectionBloc(mockObsService);

      final statuses = [
        ConnectionStatus.connecting,
        ConnectionStatus.connected,
        ConnectionStatus.notConnected,
      ];

      expectLater(
        bloc.stream,
        emitsInOrder(const [
          ObsConnectionState(ConnectionStatus.connecting),
          ObsConnectionState(ConnectionStatus.connected),
          ObsConnectionState(ConnectionStatus.notConnected),
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
