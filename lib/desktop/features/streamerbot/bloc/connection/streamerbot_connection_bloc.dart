import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_service.dart';

part 'streamerbot_connection_event.dart';
part 'streamerbot_connection_state.dart';

class StreamerBotConnectionBloc
    extends Bloc<StreamerBotConnectionEvent, StreamerBotConnectionState> {
  final StreamerBotService streamerBot;

  StreamerBotConnectionBloc(this.streamerBot)
    : super(StreamerBotConnectionState.initial()) {
    streamerBot.connectionStream.listen((connected) {
      add(StreamerBotConnectionChanged(connected));
    });

    on<StreamerBotConnectionChanged>((event, emit) {
      emit(StreamerBotConnectionState(event.status));
    });
  }
}
