import 'package:streamkeys/common/models/base_connection_data.dart';

class ObsConnectionData extends BaseConnectionData {
  const ObsConnectionData({
    super.ip,
    super.port,
    super.password,
    super.autoReconnect,
  });

  static const String _type = 'obs';

  @override
  String get prefixKey => _type;

  factory ObsConnectionData.fromMap(Map<String, dynamic> map) {
    return BaseConnectionData.mapToData<ObsConnectionData>(
      map: map,
      prefixKey: _type,
      factory: (ip, port, password, autoReconnect) {
        return ObsConnectionData(
          ip: ip,
          port: port,
          password: password,
          autoReconnect: autoReconnect,
        );
      },
    );
  }
}
