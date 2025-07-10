import 'package:streamkeys/desktop/features/obs/data/models/obs_connection_data.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_secure_storage.dart';

class ObsSettingsRepository {
  final ObsSecureStorage _secureStorage;

  ObsSettingsRepository(this._secureStorage);

  Future<ObsConnectionData?> loadConnectionData() async {
    return await _secureStorage.loadConnectionData();
  }

  Future<void> saveConnectionData(ObsConnectionData data) async {
    await _secureStorage.updateConnectionData(newData: data);
  }
}