import "dart:async";
import "dart:io";

/// Vérifie la disponibilité d'une connexion internet active.
class SplashConnectivityService {
  const SplashConnectivityService();

  // Hosts sondés en parallèle — si l'un répond, la connexion est confirmée.
  static const List<String> _hosts = ["google.com", "cloudflare.com", "1.1.1.1"];
  static const Duration _lookupTimeout = Duration(seconds: 4);
  static const Duration _retryGap = Duration(milliseconds: 600);
  static const Duration _warmup = Duration(milliseconds: 300);

  /// Retourne true dès qu'au moins un host répond.
  /// Attend un court warm-up au premier appel pour laisser la stack réseau s'initialiser,
  /// puis tente un second essai si le premier échoue, avant de déclarer hors-ligne.
  Future<bool> hasInternet() async {
    await Future.delayed(_warmup);
    if (await _probeAny()) return true;
    await Future.delayed(_retryGap);
    return _probeAny();
  }

  // Lance tous les probes en parallèle, retourne true dès qu'un seul répond positivement.
  Future<bool> _probeAny() async {
    final completer = Completer<bool>();
    int pending = _hosts.length;

    for (final host in _hosts) {
      _probe(host).then((ok) {
        if (ok && !completer.isCompleted) completer.complete(true);
        pending--;
        if (pending == 0 && !completer.isCompleted) completer.complete(false);
      });
    }

    return completer.future;
  }

  Future<bool> _probe(String host) async {
    try {
      final res = await InternetAddress.lookup(host).timeout(_lookupTimeout);
      return res.isNotEmpty && res.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
