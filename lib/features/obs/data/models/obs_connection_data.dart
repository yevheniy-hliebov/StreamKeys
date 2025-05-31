class ObsConnectionData {
  final String ip;
  final String port;
  final String password;

  String get url => 'ws://$ip:$port';

  ObsConnectionData({
    required this.ip,
    required this.port,
    required this.password,
  });

  Map<String, String> toJson() => {
        'ip': ip,
        'port': port,
        'password': password,
      };

  factory ObsConnectionData.fromJson(Map<String, String> map) {
    return ObsConnectionData(
      ip: map['ip'] ?? '',
      port: map['port'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
