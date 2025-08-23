import 'package:equatable/equatable.dart';
import 'package:streamkeys/common/models/typedef.dart';

class TwitchUserInfo extends Equatable {
  final String userId;
  final String login;
  final String displayName;
  final String avatarUrl;

  const TwitchUserInfo({
    required this.userId,
    required this.login,
    required this.displayName,
    required this.avatarUrl,
  });

  factory TwitchUserInfo.fromJson(Json json) {
    return TwitchUserInfo(
      userId: json['id'],
      login: json['login'],
      displayName: json['display_name'],
      avatarUrl: json['profile_image_url'],
    );
  }

  static bool areSameAccount(
    TwitchUserInfo? broadcaster,
    TwitchUserInfo? bot,
  ) {
    if (broadcaster == null || bot == null) return false;
    if (broadcaster.login == bot.login) return true;
    return false;
  }

  @override
  List<Object?> get props => [userId, login, displayName, avatarUrl];
}
