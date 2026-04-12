import "package:flutter_secure_storage/flutter_secure_storage.dart";

/// Gère le stockage sécurisé et persistant des données sensibles (tokens, identifiants).
class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const String _tokenKey = "auth_token";

  const SecureStorageService({
    FlutterSecureStorage storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  }) : _storage = storage;

  Future<void> write(String key, String value) async =>
      await _storage.write(key: key, value: value);

  /// @return  Valeur stockée, ou null si absente
  Future<String?> read(String key) async => await _storage.read(key: key);

  Future<void> delete(String key) async => await _storage.delete(key: key);

  Future<void> clearAll() async => await _storage.deleteAll();

  // Helpers token JWT
  Future<void> saveToken(String token) async => await write(_tokenKey, token);

  /// @return  Token JWT, ou null si aucune session active
  Future<String?> getToken() async => await read(_tokenKey);

  Future<void> deleteToken() async => await delete(_tokenKey);
}
