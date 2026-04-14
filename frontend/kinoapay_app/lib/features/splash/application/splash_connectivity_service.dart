import "dart:async";
import "package:flutter/foundation.dart";
import "splash_connectivity_service_io.dart"
    if (dart.library.html) "splash_connectivity_service_web.dart";

/// Vérifie la disponibilité d'une connexion internet active.
class SplashConnectivityService {
  const SplashConnectivityService();

  static const Duration _retryGap = Duration(milliseconds: 600);
  static const Duration _warmup = Duration(milliseconds: 300);

  Future<bool> hasInternet() async {
    if (kIsWeb) return true;
    await Future.delayed(_warmup);
    if (await probeAny()) return true;
    await Future.delayed(_retryGap);
    return probeAny();
  }
}
