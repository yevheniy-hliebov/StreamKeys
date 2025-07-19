import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/core/storage/connection_settings_repository.dart';
import 'package:streamkeys/desktop/features/obs/data/models/obs_connection_data.dart';

part 'obs_settings_event.dart';
part 'obs_settings_state.dart';

typedef ObsSettingsRepository = ConnectionSettingsRepository<ObsConnectionData>;

class ObsSettingsBloc extends Bloc<ObsSettingsEvent, ObsSettingsState> {
  final ObsSettingsRepository _repository;

  ObsSettingsBloc(this._repository) : super(ObsSettingsInitial()) {
    on<ObsSettingsLoad>((event, emit) async {
      final data = await _repository.loadConnectionData();
      emit(ObsSettingsLoaded(data));
    });
    on<ObsSettingsSave>((event, emit) async {
      await _repository.saveConnectionData(event.data);
      emit(ObsSettingsLoaded(event.data));
    });
  }
}
