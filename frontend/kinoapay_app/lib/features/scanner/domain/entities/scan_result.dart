import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/send/domain/transaction_context.dart";

/// Catégories de QR code reconnues côté client.
enum ScanResultType { publicHandle, paymentRequest, unknown }

/// Préfixe des liens de paiement partagés via URL courte.
const _kPayLinkHost = "pay.kinoapay.com";

/// Résultat décodé d'un scan QR ou d'un lien de paiement saisi manuellement.
class ScanResult extends Equatable {
  final ScanResultType type;

  /// Contenu brut du QR ou du lien saisi.
  final String raw;

  /// Identifiant public du destinataire.
  final String? publicHandle;

  /// Montant pré-rempli (optionnel).
  final double? amount;
  final String? currency;

  /// Canal de réception souhaité par le destinataire (ex. "mtn", "airtel").
  final String? destChannel;

  /// Contexte déduit du contenu : [TransactionContext.pay] si le scan
  /// provient d'une demande de paiement, [TransactionContext.send] sinon.
  final TransactionContext context;

  const ScanResult({
    required this.type,
    required this.raw,
    this.publicHandle,
    this.amount,
    this.currency,
    this.destChannel,
    this.context = TransactionContext.send,
  });

  /// Interprète une chaîne brute (deep link, URL courte ou QR) et retourne
  /// le [ScanResult] typé correspondant.
  factory ScanResult.parse(String raw) {
    final trimmed = raw.trim();

    // Lien de paiement court : https://pay.kinoapay.com/r/<token>
    if (_isPayLink(trimmed)) {
      return _parsePayLink(trimmed);
    }

    // Deep link sans montant : kinoapay://id/<handle>
    if (trimmed.startsWith("kinoapay://id/") ||
        trimmed.startsWith("kinoa://id/")) {
      final handle = trimmed.contains("kinoapay://id/")
          ? trimmed.replaceFirst("kinoapay://id/", "")
          : trimmed.replaceFirst("kinoa://id/", "");
      return ScanResult(
        type: ScanResultType.publicHandle,
        raw: trimmed,
        publicHandle: handle,
        context: TransactionContext.pay,
      );
    }

    // Deep link de paiement : kinoapay://pay/to=X&amount=Y&channel=Z&currency=XAF
    if (trimmed.startsWith("kinoapay://pay/") ||
        trimmed.startsWith("kinoa://pay/")) {
      return _parseDeepLink(trimmed);
    }

    return ScanResult(type: ScanResultType.unknown, raw: trimmed);
  }

  // ── Helpers privés ────────────────────────────────────────────────────────

  static bool _isPayLink(String raw) {
    final uri = Uri.tryParse(raw);
    return uri != null && uri.host == _kPayLinkHost;
  }

  /// Parse un lien court `https://pay.kinoapay.com/r/<token>`.
  /// Pour le MVP le token est traité comme un handle opaque — le backend
  /// le résoudra en vraies données lors de l'appel API.
  static ScanResult _parsePayLink(String raw) {
    final uri = Uri.tryParse(raw);
    final token = uri?.pathSegments.lastOrNull;
    return ScanResult(
      type: ScanResultType.paymentRequest,
      raw: raw,
      publicHandle: token,
      currency: "XAF",
      context: TransactionContext.pay,
    );
  }

  /// Parse un deep link `kinoapay://pay/to=X&amount=Y&channel=Z&currency=XAF`.
  static ScanResult _parseDeepLink(String raw) {
    final payPart = raw.startsWith("kinoapay://pay/")
        ? raw.replaceFirst("kinoapay://pay/", "https://x/?")
        : raw.replaceFirst("kinoa://pay/", "https://x/?");
    final uri = Uri.tryParse(payPart);
    final params = uri?.queryParameters ?? {};
    return ScanResult(
      type: ScanResultType.paymentRequest,
      raw: raw,
      publicHandle: params["to"],
      amount: double.tryParse(params["amount"] ?? ""),
      currency: params["currency"] ?? "XAF",
      destChannel: params["channel"],
      context: TransactionContext.pay,
    );
  }

  @override
  List<Object?> get props => [type, raw];
}
