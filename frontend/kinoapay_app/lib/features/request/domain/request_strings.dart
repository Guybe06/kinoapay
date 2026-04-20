/// Chaînes de caractères pour la feature Demander de l'argent.
/// Aucune chaîne littérale hors ce fichier.
abstract final class RequestStrings {
  static const String backLabel = "Plus";
  static const String title = "Demander";
  static const String headerSubtitle = "Générez votre QR de paiement";
  static const String pageTitle = "Demandez de l'argent.";
  static const String pageSubtitle = "Partagez ce QR ou votre identifiant.";

  // Champ montant
  static const String amountHint = "Montant (optionnel)";
  static const String amountUnit = "XAF";

  // Retours utilisateur
  static const String idCopied = "Identifiant copié.";
  static const String shareCopied = "Lien de paiement copié.";

  // Bouton principal
  static const String shareBtn = "Partager le lien de paiement";
  static const String copyLinkBtn = "Copier le lien";
  static const String linkCopied = "Lien copié !";
  static const String shareSubject = "Demande de paiement kinoaPay";

  // Label sous le QR code
  static const String qrIdLabel = "Votre KinoaID";

  // Canal de réception
  static const String channelLabel = "Recevoir sur";
  static const String channelHint = "Choisissez un canal";

  // Absence de KinoaID
  static const String noHandle = "KinoaID non disponible";

  /// URL de paiement court généré depuis le handle (MVP : lien mock).
  static String payLink(String handle, double? amount, String? channel) {
    // En production, ce token sera généré par le backend.
    final token = handle.replaceAll("@", "");
    return "https://pay.kinoapay.com/r/$token";
  }

  /// Construit le texte partageable avec le lien court.
  static String shareMessage(String handle, double? amount, String? channel) {
    final link = payLink(handle, amount, channel);
    if (amount != null && amount > 0) {
      final formatted = amount.toInt().toString().replaceAllMapped(
        RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
        (m) => "${m[1]},",
      );
      return "Envoyez-moi $formatted XAF sur kinoaPay 👉 $link";
    }
    return "Envoyez-moi de l'argent sur kinoaPay 👉 $link";
  }

  /// Génère le payload QR selon le handle et le montant.
  static String qrPayload(String handle, double? amount) {
    if (amount != null && amount > 0) {
      return "kinoapay://pay/to=$handle&amount=${amount.toInt()}&currency=XAF";
    }
    return "kinoapay://id/$handle";
  }
}
