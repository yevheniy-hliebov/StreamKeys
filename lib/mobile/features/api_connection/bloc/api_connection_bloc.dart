import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/core/storage/connection_settings_repository.dart';
import 'package:streamkeys/mobile/features/api_connection/data/models/api_connection_data.dart';

part 'api_connection_event.dart';
part 'api_connection_state.dart';

typedef ApiConnectionRepository =
    ConnectionSettingsRepository<ApiConnectionData>;

class ApiConnectionBloc extends Bloc<ApiConnectionEvent, ApiConnectionState> {
  final ApiConnectionRepository _repository;

  ApiConnectionBloc(this._repository) : super(ApiConnectionInitial()) {
    on<ApiConnectionLoad>((event, emit) async {
      final data = await _repository.loadConnectionData();
      emit(ApiConnectionLoaded(data));
    });
    on<ApiConnectionSave>((event, emit) async {
      await _repository.saveConnectionData(event.data);
      emit(ApiConnectionLoaded(event.data));
    });
  }
}
