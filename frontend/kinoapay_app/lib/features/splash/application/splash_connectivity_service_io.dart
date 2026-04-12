import "dart:async";
import "dart:io";

const List<String> _hosts = ["google.com", "cloudflare.com", "1.1.1.1"];
const Duration _timeout = Duration(seconds: 4);

Future<bool> probeAny() async {
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
