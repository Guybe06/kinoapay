import "package:equatable/equatable.dart";

/// Catégories de QR code reconnues côté client.
enum ScanResultType { publicHandle, paymentRequest, unknown }

/// Résultat décodé d'un scan QR.
class ScanResult extends Equatable {
  final ScanResultType type;

  /// Contenu brut du QR code scanné.
  final String raw;

  /// Identifiant public destinataire, disponible si [type] est [ScanResultType.publicHandle].
  final String? publicHandle;

  /// Montant pré-rempli, disponible si [type] est [ScanResultType.paymentRequest].
  final double? amount;
  final String? currency;

  const ScanResult({
    required this.type,
    required this.raw,
    this.publicHandle,
    this.amount,
    this.currency,
  });

  /// Interprète une chaîne brute et retourne le ScanResult typé correspondant.
  factory ScanResult.parse(String raw) {
    if (raw.startsWith("kinoapay://id/") || raw.startsWith("kinoa://id/")) {
      final handle = raw.startsWith("kinoapay://id/")
          ? raw.replaceFirst("kinoapay://id/", "")
          : raw.replaceFirst("kinoa://id/", "");
      return ScanResult(
        type: ScanResultType.publicHandle,
        raw: raw,
        publicHandle: handle,
      );
    }
    if (raw.startsWith("kinoapay://pay/") || raw.startsWith("kinoa://pay/")) {
      final payPart = raw.startsWith("kinoapay://pay/")
          ? raw.replaceFirst("kinoapay://pay/", "https://x/?")
          : raw.replaceFirst("kinoa://pay/", "https://x/?");
      final uri = Uri.tryParse(payPart);
      return ScanResult(
        type: ScanResultType.paymentRequest,
        raw: raw,
        publicHandle: uri?.queryParameters["to"],
        amount: double.tryParse(uri?.queryParameters["amount"] ?? ""),
        currency: uri?.queryParameters["currency"] ?? "XAF",
      );
    }
    return ScanResult(type: ScanResultType.unknown, raw: raw);
  }

  @override
  List<Object?> get props => [type, raw];
}
