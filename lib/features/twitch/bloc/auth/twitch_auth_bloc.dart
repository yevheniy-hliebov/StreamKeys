import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/twitch/data/models/twich_account.dart';
import 'package:streamkeys/features/twitch/data/repositories/twitch_repository.dart';
export 'package:streamkeys/features/twitch/data/repositories/twitch_repository.dart';

part 'twitch_auth_event.dart';
part 'twitch_auth_state.dart';

class TwitchAuthBloc extends Bloc<TwitchAuthEvent, TwitchAuthState> {
  final TwitchRepository repository;

  TwitchAuthBloc(this.repository) : super(TwitchAuthInitial()) {
    on<LoadAccounts>((event, emit) async {
      final broadcaster = await repository.loadAccount('broadcaster');
      final bot = await repository.loadAccount('bot');
      emit(TwitchAuthLoaded(broadcaster: broadcaster, bot: bot));
    });

    on<SaveAccount>((event, emit) async {
      if (event.prefix == 'broadcaster') {
        emit(TwitchAuthLoaded(
          broadcaster: state is TwitchAuthLoaded
              ? (state as TwitchAuthLoaded).broadcaster
              : null,
          bot: state is TwitchAuthLoaded
              ? (state as TwitchAuthLoaded).bot
              : null,
          isSavingBroadcaster: true,
        ));
      } else if (event.prefix == 'bot') {
        emit(TwitchAuthLoaded(
          broadcaster: state is TwitchAuthLoaded
              ? (state as TwitchAuthLoaded).broadcaster
              : null,
          bot: state is TwitchAuthLoaded
              ? (state as TwitchAuthLoaded).bot
              : null,
          isSavingBot: true,
        ));
      }

      await repository.saveAccount(event.account, event.prefix);

      final broadcaster = await repository.loadAccount('broadcaster');
      final bot = await repository.loadAccount('bot');

      emit(TwitchAuthLoaded(
        broadcaster: broadcaster,
        bot: bot,
        isSavingBroadcaster: false,
        isSavingBot: false,
      ));
    });

    add(LoadAccounts());
  }
}
