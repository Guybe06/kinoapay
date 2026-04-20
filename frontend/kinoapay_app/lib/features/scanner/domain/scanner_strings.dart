/// Chaînes de caractères pour la feature Scanner. Aucune chaîne littérale hors ce fichier.
abstract final class ScannerStrings {
  static const String title = "Scanner un QR";
  static const String hintLine1 = "Pointez vers un QR kinoaPay";
  static const String hintLine2 = "ou le KinoaID d'un contact";
  static const String cancel = "Annuler";

  static const String resultHandleTitle = "KinoaID détecté";
  static const String resultPayTitle = "Demande de paiement";
  static const String resultUnknownTitle = "QR non reconnu";
  static const String resultUnknownBody = "Ce QR code n'est pas reconnu par kinoaPay.";

  static const String actionSend = "Envoyer";
  static const String actionPay = "Payer";
  static const String actionOk = "OK";

  // Fallback lien de paiement
  static const String linkFallbackBtn = "Entrer un lien de paiement";
  static const String linkFallbackHint = "https://pay.kinoapay.com/r/...";
  static const String linkFallbackOpen = "Ouvrir";
  static const String linkFallbackError = "Lien non reconnu. Vérifiez l'URL.";

  static String resultHandleBody(String handle) =>
      "Envoyer de l'argent à $handle";

  static String resultPayBody(String amount, String currency, String handle) =>
      "Payer $amount $currency à $handle";
}
