class TwitchAccount {
  final String username;
  final String accessToken;
  final String refreshToken;
  final String clientId;
  String userId;

  TwitchAccount({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    required this.clientId,
    this.userId = '',
  });

  Map<String, String> toMap(String prefix) => {
        '${prefix}_username': username,
        '${prefix}_accessToken': accessToken,
        '${prefix}_refreshToken': refreshToken,
        '${prefix}_clientId': clientId,
        '${prefix}_userId': userId,
      };

  static TwitchAccount fromMap(Map<String, String> map, String prefix) {
    return TwitchAccount(
      username: map['${prefix}_username'] ?? '',
      accessToken: map['${prefix}_accessToken'] ?? '',
      refreshToken: map['${prefix}_refreshToken'] ?? '',
      clientId: map['${prefix}_clientId'] ?? '',
      userId: map['${prefix}_userId'] ?? '',
    );
  }
}
