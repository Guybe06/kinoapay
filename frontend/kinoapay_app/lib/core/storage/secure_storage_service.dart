import "package:flutter_secure_storage/flutter_secure_storage.dart";

/// Stockage sécurisé persistant (tokens, identifiants, préférences).
class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _userDataKey = "user_data";
  static const String _firstOpenAppKey = "first_open_app";
  static const String _channelsSetupKey = "channels_setup_done";

  const SecureStorageService({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  Future<void> write(String key, String value) => _storage.write(key: key, value: value);
  Future<String?> read(String key) => _storage.read(key: key);
  Future<void> delete(String key) => _storage.delete(key: key);
  Future<void> clearAll() => _storage.deleteAll();

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await write(_accessTokenKey, accessToken);
    await write(_refreshTokenKey, refreshToken);
  }

  Future<String?> getToken() => read(_accessTokenKey);
  Future<String?> getRefreshToken() => read(_refreshTokenKey);

  Future<void> saveToken(String token) => write(_accessTokenKey, token);
  Future<void> saveRefreshToken(String token) => write(_refreshTokenKey, token);

  Future<void> saveUserData(String json) => write(_userDataKey, json);
  Future<String?> getUserData() => read(_userDataKey);

  Future<void> clearSession() async {
    await delete(_accessTokenKey);
    await delete(_refreshTokenKey);
    await delete(_userDataKey);
  }

  Future<void> markFirstOpenApp() => write(_firstOpenAppKey, "true");
  Future<bool> isFirstOpenApp() async => (await read(_firstOpenAppKey)) != "true";

  Future<bool> isChannelsSetupDone() async => (await read(_channelsSetupKey)) == "true";
  Future<void> markChannelsSetupDone() => write(_channelsSetupKey, "true");
}
