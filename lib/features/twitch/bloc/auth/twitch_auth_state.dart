part of 'twitch_auth_bloc.dart';

sealed class TwitchAuthState extends Equatable {
  final bool isSavingBroadcaster;
  final bool isSavingBot;

  const TwitchAuthState(
      {this.isSavingBroadcaster = false, this.isSavingBot = false});

  @override
  List<Object?> get props => [isSavingBroadcaster, isSavingBot];
}

class TwitchAuthInitial extends TwitchAuthState {}

class TwitchAuthLoaded extends TwitchAuthState {
  final TwitchAccount? broadcaster;
  final TwitchAccount? bot;

  const TwitchAuthLoaded({
    this.broadcaster,
    this.bot,
    super.isSavingBroadcaster,
    super.isSavingBot,
  });

  @override
  List<Object?> get props =>
      [broadcaster, bot, isSavingBroadcaster, isSavingBot];
}
