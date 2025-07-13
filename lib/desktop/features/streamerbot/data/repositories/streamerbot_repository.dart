import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_connection_data.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_secure_storage.dart';

class StreamerBotSettingsRepository {
  final StreamerBotSecureStorage _secureStorage;

  StreamerBotSettingsRepository(this._secureStorage);

  Future<StreamerBotConnectionData?> loadConnectionData() async {
    return await _secureStorage.loadConnectionData();
  }

  Future<void> saveConnectionData(StreamerBotConnectionData data) async {
    await _secureStorage.updateConnectionData(newData: data);
  }
}
