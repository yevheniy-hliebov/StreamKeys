import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_connection_data.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/repositories/streamerbot_repository.dart';

part 'streamerbot_settings_event.dart';
part 'streamerbot_settings_state.dart';

class StreamerBotSettingsBloc
    extends Bloc<StreamerBotSettingsEvent, StreamerBotSettingsState> {
  final StreamerBotSettingsRepository _repository;

  StreamerBotSettingsBloc(this._repository)
      : super(StreamerBotSettingsInitial()) {
    on<StreamerBotSettingsLoad>((event, emit) async {
      final data = await _repository.loadConnectionData();
      emit(StreamerBotSettingsLoaded(data));
    });
    on<StreamerBotSettingsSave>((event, emit) async {
      await _repository.saveConnectionData(event.data);
      emit(StreamerBotSettingsLoaded(event.data));
    });
  }
}
