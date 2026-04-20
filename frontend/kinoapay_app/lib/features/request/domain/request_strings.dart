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
  static const String shareBtn = "Copier le lien de paiement";

  // Label sous le QR code
  static const String qrIdLabel = "Votre KinoaID";

  // Absence de KinoaID
  static const String noHandle = "KinoaID non disponible";

  /// Construit le texte partageable selon le montant saisi.
  static String shareMessage(String handle, double? amount) {
    if (amount != null && amount > 0) {
      final formatted = amount.toInt().toString().replaceAllMapped(
        RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
        (m) => "${m[1]},",
      );
      return "Envoyez-moi $formatted XAF sur kinoaPay : $handle";
    }
    return "Envoyez-moi de l'argent sur kinoaPay : $handle";
  }

  /// Génère le payload QR selon le handle et le montant.
  static String qrPayload(String handle, double? amount) {
    if (amount != null && amount > 0) {
      return "kinoapay://pay/to=$handle&amount=${amount.toInt()}&currency=XAF";
    }
    return "kinoapay://id/$handle";
  }
}
