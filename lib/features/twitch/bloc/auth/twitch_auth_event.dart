part of 'twitch_auth_bloc.dart';

sealed class TwitchAuthEvent {}

class LoadAccounts extends TwitchAuthEvent {}

class SaveAccount extends TwitchAuthEvent {
  final TwitchAccount account;
  final String prefix;
  SaveAccount(this.account, this.prefix);
}
