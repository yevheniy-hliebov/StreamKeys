import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_service.dart';

part 'obs_connection_event.dart';
part 'obs_connection_state.dart';

class ObsConnectionBloc extends Bloc<ObsConnectionEvent, ObsConnectionState> {
  final ObsService obs;

  ObsConnectionBloc(this.obs) : super(ObsConnectionState.initial()) {
    obs.connectionStream.listen((connected) {
      add(ObsConnectionChanged(connected));
    });

    on<ObsConnectionChanged>((event, emit) {
      emit(ObsConnectionState(event.status));
    });
  }
}
