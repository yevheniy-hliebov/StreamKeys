import 'package:streamkeys/core/storage/secure_storable.dart';

abstract class BaseConnectionData extends SecureStorable {
  final String ip;
  final String port;
  final String password;
  final bool autoReconnect;

  const BaseConnectionData({
    this.ip = '',
    this.port = '',
    this.password = '',
    this.autoReconnect = false,
  });

  String get prefixKey => '';

  String get url => 'ws://$ip:$port';

  @override
  Map<String, dynamic> toMap() {
    return {
      '${prefixKey}_ip': ip,
      '${prefixKey}_port': port,
      '${prefixKey}_password': password,
      '${prefixKey}_auto_reconnect': autoReconnect.toString(),
    };
  }

  static T mapToData<T extends BaseConnectionData>({
    required Map<String, dynamic> map,
    required String prefixKey,
    required T Function(
      String ip,
      String port,
      String password,
      bool autoReconnect,
    ) factory,
  }) {
    return factory(
      map['${prefixKey}_ip'] ?? '',
      map['${prefixKey}_port'] ?? '',
      map['${prefixKey}_password'],
      map['${prefixKey}_auto_reconnect'] == 'true',
    );
  }

  @override
  List<Object?> get props => [ip, port, password, autoReconnect];
}
