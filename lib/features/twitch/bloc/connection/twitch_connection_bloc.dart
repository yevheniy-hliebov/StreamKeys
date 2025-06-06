import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/features/twitch/bloc/auth/twitch_auth_bloc.dart';
import 'package:streamkeys/features/twitch/bloc/connection/twitch_connection_event.dart';
import 'package:streamkeys/features/twitch/bloc/connection/twitch_connection_state.dart';
import 'package:streamkeys/features/twitch/data/repositories/twitch_connection_service.dart';

class TwitchConnectionBloc
    extends Bloc<TwitchConnectionEvent, TwitchConnectionState> {
  final TwitchRepository repository;
  final TwitchConnectionService service;
  Timer? _timer;

  TwitchConnectionBloc(this.repository, this.service)
      : super(const TwitchConnectionState(
          broadcaster: ConnectionStatus.notConnected,
          bot: ConnectionStatus.notConnected,
        )) {
    on<StartConnectionChecks>((event, emit) {
      _timer?.cancel();
      _timer = Timer.periodic(
          const Duration(seconds: 30), (_) => add(CheckConnection()));
      add(CheckConnection());
    });

    on<CheckConnection>((event, emit) async {
      final broadcaster = await repository.loadAccount('broadcaster');
      final bot = await repository.loadAccount('bot');

      final bStatus = (broadcaster != null)
          ? await service.checkConnection(
              accessToken: broadcaster.accessToken,
              clientId: broadcaster.clientId,
            )
          : ConnectionStatus.notConnected;

      final botStatus = (bot != null)
          ? await service.checkConnection(
              accessToken: bot.accessToken,
              clientId: bot.clientId,
            )
          : ConnectionStatus.notConnected;

      emit(TwitchConnectionState(broadcaster: bStatus, bot: botStatus));
    });

    add(StartConnectionChecks());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
