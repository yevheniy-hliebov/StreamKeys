import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpServerPasswordService {
  static const _storageKey = 'http_password';
  final _storage = const FlutterSecureStorage();

  Future<String> loadOrCreatePassword() async {
    final saved = await _storage.read(key: _storageKey);
    if (saved != null) return saved;
    return generateAndSavePassword();
  }

  Future<String> generateAndSavePassword() async {
    final newPass = _generatePassword();
    await _storage.write(key: _storageKey, value: newPass);
    return newPass;
  }

  String _generatePassword() {
    const length = 16;
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_=+[]{}|;:,.<>?';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}
