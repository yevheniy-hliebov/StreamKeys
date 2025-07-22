import 'package:streamkeys/common/models/base_connection_data.dart';

class StreamerBotConnectionData extends BaseConnectionData {
  const StreamerBotConnectionData({
    super.ip,
    super.port,
    super.password,
    super.autoReconnect,
  });

  static const String _type = 'streamerbot';

  @override
  String get prefixKey => _type;

  factory StreamerBotConnectionData.fromMap(Map<String, dynamic> map) {
    return BaseConnectionData.mapToData<StreamerBotConnectionData>(
      map: map,
      prefixKey: _type,
      factory: (ip, port, password, autoReconnect) {
        return StreamerBotConnectionData(
          ip: ip,
          port: port,
          password: password,
          autoReconnect: autoReconnect,
        );
      },
    );
  }
}
