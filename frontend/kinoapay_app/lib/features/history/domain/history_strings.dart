/// Chaînes de l'interface Historique des transactions.
abstract final class HistoryStrings {
  static const String backLabel = "Plus";
  static const String title = "Historique";
  static const String pageTitle = "Retracez vos flux.";
  static const String pageSubtitle = "Chaque mouvement, chaque période.";
  static const String subtitle = "Toutes vos transactions";
  static const String headerSubtitle = "Vos mouvements par période";
  static const String empty = "Aucune transaction sur cette période";
  static const String emptySubtitle = "Modifiez les filtres ou naviguez vers une autre période.";

  static const String today = "Aujourd'hui";
  static const String yesterday = "Hier";

  static const String periodMonth = "Ce mois";
  static const String period3Months = "3 mois";
  static const String periodYear = "Cette année";

  static const String dirAll = "Tous";
  static const String dirSent = "Envoyé";
  static const String dirReceived = "Reçu";
  static const String dirPending = "En attente";

  static const String channelAll = "Tous";
  static const String channelMtn = "MTN";
  static const String channelAirtel = "Airtel";

  static const String filterTitle = "Filtres";
  static const String filterReset = "Réinitialiser";
  static const String filterLabelPeriod = "Période";
  static const String filterLabelDirection = "Direction";
  static const String filterLabelCanal = "Canal";

  static const String statsSent = "ENVOYÉ";
  static const String statsReceived = "REÇU";
  static const String statsNet = "NET";

  static const String sheetStatusCompleted = "Complété";
  static const String sheetStatusPending = "En attente";
  static const String sheetStatusProcessing = "En traitement";
  static const String sheetStatusFailed = "Échoué";

  static const String sheetFrom = "De";
  static const String sheetTo = "Vers";
  static const String sheetFor = "Pour";
  static const String sheetRef = "Référence";
  static const String sheetDate = "Date";

  static const String sheetFeeSection = "Frais";
  static const String sheetFeeOperator = "Opérateur source";
  static const String sheetFeePlatform = "KinoaPay";
  static const String sheetFeeTotal = "Total frais";
  static const String sheetDebited = "Montant débité";
  static const String sheetReceived = "Montant reçu";

  static const String sheetQrTitle = "Reçu numérique";
  static const String sheetQrSub = "Référence unique de la transaction";
  static const String qrHeader = "REÇU KINOAPAY";
  static const String qrLabelRef = "Réf";
  static const String qrLabelAmount = "Montant";
  static const String qrLabelSentTo = "Envoyé à";
  static const String qrLabelReceivedFrom = "Reçu de";
  static const String qrLabelChannel = "Canal";
  static const String qrLabelDate = "Date";
  static const String qrLabelStatus = "Statut";
  static const String copyRef = "Copier la référence";
  static const String copiedRef = "Référence copiée !";

  static const String currency = "XAF";
  static const String errorLoad = "Impossible de charger l'historique.";

  static String amountWith(String a) => "$a XAF";
}
