part of 'twitch_bloc.dart';

class TwitchState extends Equatable {
  final TwitchUserInfo? broadcaster;
  final TwitchUserInfo? bot;

  const TwitchState({
    this.broadcaster,
    this.bot,
  });

  TwitchState copyWith({TwitchUserInfo? broadcaster, TwitchUserInfo? bot}) {
    return TwitchState(
      broadcaster: broadcaster ?? this.broadcaster,
      bot: bot ?? this.bot,
    );
  }

  @override
  List<Object?> get props => [broadcaster, bot];
}
