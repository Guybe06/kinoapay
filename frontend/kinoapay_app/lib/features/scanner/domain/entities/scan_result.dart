import "package:equatable/equatable.dart";

/// Catégories de QR code reconnues côté client.
enum ScanResultType { kinoaId, paymentRequest, unknown }

/// Résultat décodé d'un scan QR.
class ScanResult extends Equatable {
  final ScanResultType type;

  /// Contenu brut du QR code scanné.
  final String raw;

  /// KinoaID destinataire, disponible si [type] est [ScanResultType.kinoaId].
  final String? kinoaId;

  /// Montant pré-rempli, disponible si [type] est [ScanResultType.paymentRequest].
  final double? amount;
  final String? currency;

  const ScanResult({
    required this.type,
    required this.raw,
    this.kinoaId,
    this.amount,
    this.currency,
  });

  /// Interprète une chaîne brute et retourne le ScanResult typé correspondant.
  factory ScanResult.parse(String raw) {
    if (raw.startsWith("kinoa://id/")) {
      return ScanResult(
        type: ScanResultType.kinoaId,
        raw: raw,
        kinoaId: raw.replaceFirst("kinoa://id/", ""),
      );
    }
    if (raw.startsWith("kinoa://pay/")) {
      final uri = Uri.tryParse(raw.replaceFirst("kinoa://pay/", "https://x/?"));
      return ScanResult(
        type: ScanResultType.paymentRequest,
        raw: raw,
        kinoaId: uri?.queryParameters["to"],
        amount: double.tryParse(uri?.queryParameters["amount"] ?? ""),
        currency: uri?.queryParameters["currency"] ?? "XAF",
      );
    }
    return ScanResult(type: ScanResultType.unknown, raw: raw);
  }

  @override
  List<Object?> get props => [type, raw];
}
