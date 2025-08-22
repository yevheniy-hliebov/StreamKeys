part of 'twitch_bloc.dart';

class TwitchState extends Equatable {
  final TwitchUserStatus broadcaster;
  final TwitchUserStatus bot;

  const TwitchState({
    this.broadcaster = const TwitchUserStatus(connected: false),
    this.bot = const TwitchUserStatus(connected: false),
  });

  TwitchState copyWith({TwitchUserStatus? broadcaster, TwitchUserStatus? bot}) {
    return TwitchState(
      broadcaster: broadcaster ?? this.broadcaster,
      bot: bot ?? this.bot,
    );
  }

  @override
  List<Object> get props => [broadcaster, bot];
}
