import 'package:bloc/bloc.dart';
import 'package:streamkeys/common/models/connection_status.dart';

part 'integration_connection_event.dart';
part 'integration_connection_state.dart';

class IntegrationConnectionBloc
    extends Bloc<IntegrationConnectionEvent, IntegrationConnectionState> {
  IntegrationConnectionBloc({
    required Stream<ConnectionStatus> subcription,
    Future<void> Function()? check,
  }) : super(IntegrationConnectionState.initial()) {
    subcription.listen((connected) {
      add(IntegrationConnectionChanged(connected));
    });

    on<IntegrationConnectionChanged>((event, emit) {
      emit(IntegrationConnectionState(event.status));
    });

    on<IntegrationConnectionCheck>((event, emit) {
      check?.call();
    });
  }
}
