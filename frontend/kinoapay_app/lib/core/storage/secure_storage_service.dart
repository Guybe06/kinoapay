import "package:flutter_secure_storage/flutter_secure_storage.dart";

/// Gère le stockage sécurisé et persistant des données sensibles (tokens, identifiants, préférences app).
class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const String _tokenKey = "auth_token";
  static const String _firstOpenAppKey = "first_open_app";

  const SecureStorageService({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  /// Ecrit une valeur chiffrée pour la clé donnée.
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  /// Lit la valeur chiffrée pour la clé donnée, null si absente.
  Future<String?> read(String key) => _storage.read(key: key);

  /// Supprime l'entrée associée à la clé.
  Future<void> delete(String key) => _storage.delete(key: key);

  /// Supprime toutes les entrées du stockage sécurisé.
  Future<void> clearAll() => _storage.deleteAll();

  // Gestion du token JWT
  Future<void> saveToken(String token) => write(_tokenKey, token);
  Future<String?> getToken() => read(_tokenKey);
  Future<void> deleteToken() => delete(_tokenKey);

  /// Supprime uniquement la session (token), conserve first_open_app et les autres préférences.
  Future<void> clearSession() => deleteToken();

  // first_open_app : true après le premier signin ou signup réussi.
  // Persiste entre les sessions pour router directement vers signin plutôt que welcome.
  Future<void> markFirstOpenApp() => write(_firstOpenAppKey, "true");
  Future<bool> isFirstOpenApp() async => (await read(_firstOpenAppKey)) != "true";

  // Comptes de paiement : true si l'utilisateur a configuré ou ignoré l'étape setup.
  static const String _channelsSetupKey = "channels_setup_done";
  Future<bool> isChannelsSetupDone() async => (await read(_channelsSetupKey)) == "true";
  Future<void> markChannelsSetupDone() => write(_channelsSetupKey, "true");
}
