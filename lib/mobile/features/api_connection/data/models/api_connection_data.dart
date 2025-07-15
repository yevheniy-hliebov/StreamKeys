import 'package:streamkeys/common/models/base_connection_data.dart';

class ApiConnectionData extends BaseConnectionData {
  const ApiConnectionData({
    super.ip,
    super.port,
    super.password,
  }) : super(autoReconnect: false);

  bool get isEmpty {
    return ip.isEmpty && port.isEmpty && password.isEmpty;
  }

  bool get isNotEmpty => !isEmpty;

  static const String _type = 'http_api';

  @override
  String get prefixKey => _type;

  factory ApiConnectionData.fromMap(Map<String, dynamic> map) {
    return BaseConnectionData.mapToData<ApiConnectionData>(
      map: map,
      prefixKey: _type,
      factory: (ip, port, password, _) {
        return ApiConnectionData(
          ip: ip,
          port: port,
          password: password,
        );
      },
    );
  }
}
