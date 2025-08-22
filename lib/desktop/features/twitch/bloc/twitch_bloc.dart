import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/twitch/data/models/twitch_user_status.dart';
import 'package:streamkeys/desktop/features/twitch/data/services/twitch_auth_checker.dart';
import 'package:streamkeys/desktop/features/twitch/data/services/twitch_auth_service.dart';

part 'twitch_event.dart';
part 'twitch_state.dart';

class TwitchBloc extends Bloc<TwitchEvent, TwitchState> {
  final TwitchAuthService _authService;
  final TwitchAuthChecker _authChecker;

  StreamSubscription<TwitchUserStatus>? _broadcasterSub;
  StreamSubscription<TwitchUserStatus>? _botSub;

  TwitchBloc(this._authService, this._authChecker)
    : super(const TwitchState()) {
    on<TwitchLogin>((event, emit) async {
      await _authService.login(isBot: event.isBot);
    });

    on<TwitchLogout>((event, emit) async {
      await _authService.logout(isBot: event.isBot);
      if (event.isBot) {
        await _authChecker.refreshBot();
        emit(state.copyWith(bot: const TwitchUserStatus(connected: false)));
      } else {
        await _authChecker.refreshBroadcaster();
        emit(
          state.copyWith(broadcaster: const TwitchUserStatus(connected: false)),
        );
      }
    });

    on<TwitchChangeStatus>((event, emit) {
      emit(
        state.copyWith(
          broadcaster: event.broadcaster ?? state.broadcaster,
          bot: event.bot ?? state.bot,
        ),
      );
    });

    on<TwitchStartChecking>((event, emit) {
      _broadcasterSub?.cancel();
      _botSub?.cancel();

      _broadcasterSub = _authChecker.broadcasterStatus.listen((userStatus) {
        add(TwitchChangeStatus(broadcaster: userStatus));
      });

      _botSub = _authChecker.botStatus.listen((userStatus) {
        add(TwitchChangeStatus(bot: userStatus));
      });
    });
  }

  @override
  Future<void> close() {
    _broadcasterSub?.cancel();
    _botSub?.cancel();
    return super.close();
  }
}
