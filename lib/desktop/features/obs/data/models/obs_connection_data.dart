import 'package:equatable/equatable.dart';

class ObsConnectionData extends Equatable {
  final String ip;
  final String port;
  final String password;
  final bool autoReconnect;

  String get url => 'ws://$ip:$port';

  const ObsConnectionData({
    required this.ip,
    required this.port,
    required this.password,
    required this.autoReconnect,
  });

  Map<String, String> toMap() {
    return {
      'obs_ip': ip,
      'obs_port': port,
      'obs_password': password,
      'obs_auto_reconnect': autoReconnect.toString(),
    };
  }

  factory ObsConnectionData.fromMap(Map<String, String> map) {
    return ObsConnectionData(
      ip: map['obs_ip'] ?? '',
      port: map['obs_port'] ?? '',
      password: map['obs_password'] ?? '',
      autoReconnect: map['obs_auto_reconnect'] == 'true',
    );
  }

  @override
  List<Object?> get props => [ip, port, password, autoReconnect];
}
