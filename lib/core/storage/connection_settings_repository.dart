import 'package:streamkeys/core/storage/generic_secure_storage.dart';
import 'package:streamkeys/core/storage/secure_storable.dart';

class ConnectionSettingsRepository<T extends SecureStorable> {
  final GenericSecureStorage<T> _secureStorage;

  ConnectionSettingsRepository(this._secureStorage);

  Future<T?> loadConnectionData() {
    return _secureStorage.loadConnectionData();
  }

  Future<void> saveConnectionData(T data) {
    return _secureStorage.updateConnectionData(newData: data);
  }
}
