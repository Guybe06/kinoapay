import "package:flutter/foundation.dart" show kIsWeb;
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:shared_preferences/shared_preferences.dart";

/// Stockage sécurisé persistant (tokens, identifiants, préférences).
/// Sur mobile : flutter_secure_storage (chiffrement natif).
/// Sur web : shared_preferences (localStorage — Web Crypto non disponible sur HTTP).
class SecureStorageService {
  final FlutterSecureStorage _mobileStorage;

  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _userDataKey = "user_data";
  static const String _firstOpenAppKey = "first_open_app";
  static const String _channelsSetupKey = "channels_setup_done";

  SecureStorageService({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _mobileStorage = storage;

  Future<SharedPreferences> get _webPrefs => SharedPreferences.getInstance();

  Future<void> write(String key, String value) async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.setString(key, value);
    } else {
      await _mobileStorage.write(key: key, value: value);
    }
  }

  Future<String?> read(String key) async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      return prefs.getString(key);
    }
    return _mobileStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.remove(key);
    } else {
      await _mobileStorage.delete(key: key);
    }
  }

  Future<void> clearAll() async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.clear();
    } else {
      await _mobileStorage.deleteAll();
    }
  }

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
