import 'package:equatable/equatable.dart';

class TwitchUserStatus extends Equatable {
  final bool connected;
  final String? login;
  final String? displayName;
  final String? avatarUrl;

  const TwitchUserStatus({
    required this.connected,
    this.login,
    this.displayName,
    this.avatarUrl,
  });
  
  @override
  List<Object?> get props => [connected, login, displayName, avatarUrl];
}
