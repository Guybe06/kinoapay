import "dart:io";

/// Vérifie la disponibilité d'une connexion internet active.
class SplashConnectivityService {
  const SplashConnectivityService();

  /// Tente une résolution DNS pour confirmer l'accès à internet.
  /// @return  true si la résolution réussit, false en cas d'erreur ou de timeout
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup("google.com")
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
