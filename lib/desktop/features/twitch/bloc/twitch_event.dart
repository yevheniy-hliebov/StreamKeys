part of 'twitch_bloc.dart';

sealed class TwitchEvent extends Equatable {
  const TwitchEvent();

  @override
  List<Object> get props => [];
}

class TwitchLogin extends TwitchEvent {
  final bool isBot;
  const TwitchLogin({required this.isBot});
}

class TwitchLogout extends TwitchEvent {
  final bool isBot;
  const TwitchLogout({required this.isBot});
}

class TwitchStartChecking extends TwitchEvent {}

class TwitchChangeStatus extends TwitchEvent {
  final TwitchUserStatus? broadcaster;
  final TwitchUserStatus? bot;

  const TwitchChangeStatus({this.broadcaster, this.bot});
}