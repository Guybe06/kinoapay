/// Codes d'erreur globaux de l'application KinoaPay.
/// Chaque feature complète ces codes dans son fichier [feature]_error_codes.dart situé dans son dossier domain/.
class KinoaErrorCodes {
  // Réseau
  static const String network = "NETWORK_ERROR";
  static const String timeout = "TIMEOUT_ERROR";
  static const String noInternet = "NO_INTERNET";
  // Authentification
  static const String unauthorized = "UNAUTHORIZED";
  static const String tokenExpired = "TOKEN_EXPIRED";
  static const String tokenInvalid = "TOKEN_INVALID";
  static const String sessionRevoked = "SESSION_REVOKED";
  // Serveur
  static const String serverError = "SERVER_ERROR";
  static const String serviceUnavailable = "SERVICE_UNAVAILABLE";
  static const String notFound = "NOT_FOUND";
  static const String conflict = "CONFLICT";
  static const String rateLimited = "RATE_LIMITED";
  // Validation globale
  static const String validationError = "VALIDATION_ERROR";
  static const String missingField = "MISSING_FIELD";
  static const String invalidFormat = "INVALID_FORMAT";
  // Stockage local (secure storage, etc.)
  static const String localStorage = "LOCAL_STORAGE";
  // Générique
  static const String unknown = "UNKNOWN_ERROR";
  static const String cancelled = "CANCELLED";
}
