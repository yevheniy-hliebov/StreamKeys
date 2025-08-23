import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:streamkeys/desktop/features/twitch/data/models/twitch_user_info.dart';
import 'package:streamkeys/desktop/features/twitch/data/services/twitch_auth_checker.dart';
import 'package:streamkeys/desktop/features/twitch/data/services/twitch_auth_service.dart';

part 'twitch_event.dart';
part 'twitch_state.dart';

class TwitchBloc extends Bloc<TwitchEvent, TwitchState> {
  final TwitchAuthService _authService;
  final TwitchAuthChecker _authChecker;

  StreamSubscription<TwitchUserInfo?>? _broadcasterSub;
  StreamSubscription<TwitchUserInfo?>? _botSub;

  TwitchBloc(this._authService, this._authChecker)
    : super(const TwitchState()) {
    on<TwitchLogin>((event, emit) async {
      await _authService.login(isBot: event.isBot);
    });

    on<TwitchLogout>((event, emit) async {
      await _authService.logout(isBot: event.isBot);
      if (event.isBot) {
        await _authChecker.refreshBot();
      } else {
        await _authChecker.refreshBroadcaster();
      }
    });

    on<TwitchChangeStatus>((event, emit) {
      emit(
        state.copyWith(
          broadcaster: !event.isBot ? () => event.userInfo : null,
          bot: event.isBot ? () => event.userInfo : null,
        ),
      );
    });

    on<TwitchStartChecking>((event, emit) {
      _broadcasterSub?.cancel();
      _botSub?.cancel();

      _broadcasterSub = _authChecker.broadcasterInfoStream.listen((userInfo) {
        add(TwitchChangeStatus(userInfo: userInfo, isBot: false));
      });

      _botSub = _authChecker.botInfoStream.listen((userInfo) {
        add(TwitchChangeStatus(userInfo: userInfo, isBot: true));
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
