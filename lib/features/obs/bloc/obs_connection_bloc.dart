import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/features/obs/data/models/obs_connection_data.dart';
import 'package:streamkeys/features/obs/data/repositories/obs_connection_repository.dart';

part 'obs_connection_event.dart';
part 'obs_connection_state.dart';

class ObsConnectionBloc extends Bloc<ObsConnectionEvent, ObsConnectionState> {
  final ObsConnectionRepository _repository;
  ObsConnectionData? data;
  bool autoReconnect = false;
  Timer? _reconnectTimer;

  ObsConnectionBloc(this._repository) : super(const ObsConnectionInitial()) {
    on<ObsConnectionConnectEvent>(_onConnect);
    on<ObsConnectionDisconnectEvent>((event, emit) => _onDisconnect(emit));
    on<ObsConnectionReconnectEvent>(_onReconnect);
    on<ObsConnectionToggleAutoReconnectEvent>(_onToggleAutoReconnect);

    _initAutoReconnect();
    add(const ObsConnectionConnectEvent());
  }

  Future<void> _initAutoReconnect() async {
    autoReconnect = await _repository.loadAutoReconnect();
    if (autoReconnect) {
      _startAutoReconnectTimer();
    }
  }

  Future<void> _onConnect(
    ObsConnectionConnectEvent event,
    Emitter<ObsConnectionState> emit,
  ) async {
    emit(ObsConnectionLoading(data, autoReconnect));
    try {
      if (event.updatedConnectionData != null) {
        data = event.updatedConnectionData!;
        await _repository.updateConnectionData(data!);
      } else {
        data = await _repository.loadConnectionData();
      }

      await _repository.connect();
      emit(ObsConnectionConnected(data, autoReconnect));
    } catch (e) {
      emit(ObsConnectionError(e.toString(), data, autoReconnect));
    }
  }

  Future<void> _onDisconnect(Emitter<ObsConnectionState> emit) async {
    emit(ObsConnectionLoading(data, autoReconnect));
    try {
      await _repository.disconnect();
      emit(ObsConnectionInitial(data, autoReconnect));
    } catch (e) {
      emit(ObsConnectionError(e.toString(), data, autoReconnect));
    }
  }

  Future<void> _onReconnect(
    ObsConnectionReconnectEvent event,
    Emitter<ObsConnectionState> emit,
  ) async {
    emit(ObsConnectionLoading(data, autoReconnect));
    try {
      if (event.updatedConnectionData != null) {
        data = event.updatedConnectionData!;
        await _repository.updateConnectionData(data!);
      } else {
        data = await _repository.loadConnectionData();
      }
      await _repository.reconnect();
      emit(ObsConnectionConnected(data, autoReconnect));
    } catch (e) {
      emit(ObsConnectionError(e.toString(), data, autoReconnect));
    }
  }

  Future<void> _onToggleAutoReconnect(
    ObsConnectionToggleAutoReconnectEvent event,
    Emitter<ObsConnectionState> emit,
  ) async {
    autoReconnect = event.enabled;
    await _repository.saveAutoReconnect(autoReconnect);

    if (autoReconnect) {
      _startAutoReconnectTimer();
    } else {
      _stopAutoReconnectTimer();
    }

    // Переемітимо стан з оновленим авто перепідключенням
    emit(state.runtimeType == ObsConnectionConnected
        ? ObsConnectionConnected(data, autoReconnect)
        : ObsConnectionInitial(data, autoReconnect));
  }

  void _startAutoReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (state is! ObsConnectionLoading) {
        add(const ObsConnectionReconnectEvent());
      }
    });
  }

  void _stopAutoReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  @override
  Future<void> close() {
    _stopAutoReconnectTimer();
    return super.close();
  }
}
