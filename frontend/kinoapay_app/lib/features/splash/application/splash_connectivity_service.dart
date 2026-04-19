import "dart:async";
import "dart:io";

const List<String> _hosts = ["google.com", "cloudflare.com", "1.1.1.1"];
const Duration _timeout = Duration(seconds: 4);

/// Vérifie la disponibilité d'une connexion internet active.
class SplashConnectivityService {
  const SplashConnectivityService();

  static const Duration _retryGap = Duration(milliseconds: 600);
  static const Duration _warmup = Duration(milliseconds: 300);

  Future<bool> hasInternet() async {
    await Future.delayed(_warmup);
    if (await _probeAny()) return true;
    await Future.delayed(_retryGap);
    return _probeAny();
  }
}

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
    final res = await InternetAddress.lookup(host).timeout(_timeout);
    return res.isNotEmpty && res.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
