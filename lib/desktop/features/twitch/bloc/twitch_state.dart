part of 'twitch_bloc.dart';

class TwitchState extends Equatable {
  final TwitchUserInfo? broadcaster;
  final TwitchUserInfo? bot;

  const TwitchState({this.broadcaster, this.bot});

  TwitchState copyWith({
    ValueGetter<TwitchUserInfo?>? broadcaster,
    ValueGetter<TwitchUserInfo?>? bot,
  }) {
    return TwitchState(
      broadcaster: broadcaster != null ? broadcaster() : this.broadcaster,
      bot: bot != null ? bot() : this.bot,
    );
  }

  @override
  List<Object?> get props => [broadcaster, bot];
}
