/// Strings UI de la feature Envoi d'argent. Aucune chaîne littérale hors ce fichier.
abstract final class SendStrings {
  static const String title = "Envoyer";
  static const String pageTitle = "Envoyez simplement.";

  static const String stepRecipientTitle = "À qui envoyez-vous ?";
  static const String stepRecipientSub = "Par numéro ou identifiant Kinoa.";
  static const String stepAmountTitle = "Combien envoyez-vous ?";
  static const String stepAmountSub = "Choisissez le montant et les comptes.";

  static const String backToDashboard = "Accueil";
  static const String backToRecipient = "Destinataire";

  static const String headerTitleRecipient = "Envoyer";
  static const String headerSubRecipient = "Définissez le bénéficiaire";
  static const String headerTitleAmount = "Montant";
  static const String headerSubAmount = "Définissez le virement";

  static const String recipientHint = "Numéro sans code pays ou @ID Kinoa";
  static const String phoneHint = "Ex: 06 444 55 66";
  static const String idHint = "Identifiant Kinoa";
  static const String switchPhone = "Numéro de tél.";
  static const String switchId = "@ID_KINOAPAY";
  static const String idPrefix = "@";
  static const String recentContactsLabel = "CONTACTS RÉCENTS";
  static const String contactsBtn = "Tous les contacts";
  static const String kinoaUserTag = "kinoaPay";
  static const String merchantUserTag = "Marchand";
  static const String externalUserTag = "Externe";
  static const String notOnKinoaLabel =
      "Pas sur kinoaPay ? Envoyez directement.";
  static const String sendExternalBtn = "Envoyer vers ce numéro";

  static const String sourceLabel = "DEPUIS";
  static const String destLabel = "VERS";

  static const String amountDisplayLabel = "MONTANT";
  static const String amountHint = "0";
  static const String amountUnit = "XAF";

  static const String continueBtn = "Continuer";
  static const String modifyBtn = "Modifier";
  static const String cancelBtn = "Annuler";
  static const String confirmBtn = "Confirmer l'envoi";
  static const String simulateBtn = "Simuler les frais";

  static const String backLabel = "Retour";
  static const String confirmTitle = "Vérification";
  static const String confirmSubtitle = "Confirmez votre transaction";
  static const String confirmToLabel = "Vers";
  static const String confirmAmountLabel = "Montant";
  static const String confirmTotalLabel = "Total à débiter";
  static const String feeKinoa = "Frais Kinoa";
  static const String feeOperator = "Frais Opérateur";

  static const String totalFeesLabel = "Frais";
  static const String confirmRecipientLabel = "Destinataire";
  static const String confirmSourceLabel = "Depuis";

  static const String processing = "Traitement sécurisé...";
  static const String successTitle = "Envoi en cours";
  static const String successMessage =
      "Votre transfert est en cours de traitement. Vous serez notifié dès que l'opération sera finalisée.";
  static const String successBackBtn = "Retour à l'accueil";

  static const String ussdTitle = "Validation en cours";
  static const String ussdMessage =
      "Veuillez confirmer le retrait des fonds via votre opérateur mobile. L'opération sera validée automatiquement.";
  static const String ussdConfirmBtn = "J'ai confirmé";
  static const String ussdBackLabel = "Envoi";

  static const String processingTitle = "Traitement";

  static const String infoUnsupportedCountry =
      "Ce contact n'est pas encore disponible sur kinoaPay.";
  static const String errorNoAmount = "Entrez un montant valide.";
  static const String errorNoChannel = "Sélectionnez un canal de destination.";
  static const String errorNoSourceAccount =
      "Sélectionnez un compte à débiter.";
  static const String errorMinLength = "Entrez au moins 3 caractères";
  static const String errorMinPhoneLength = "Entrez au moins 4 chiffres";
  static const String errorUserNotFound = "Utilisateur non trouvé";

  static const String notifChannelId = "kinoapay_channel";
  static const String notifChannelName = "KinoaPay Notifications";
  static const String notifChannelDesc =
      "Notifications pour les transactions KinoaPay";
  static const String notifIconResource = "@drawable/ic_stat_notification";
  static const String notifIconName = "ic_stat_notification";
  static const String notifSuccessTitle = "Envoi confirmé";
  static const String notifSuccessBody =
      "Votre envoi a été confirmé avec succès";

  // Étape de confirmation du devis
  static const String quoteVerifyTitle = "Vérifiez l'envoi";
  static const String quoteVerifySubtitle = "Dernière étape avant la confirmation";
  static const String quoteWillReceive = "va recevoir";

  // Contexte paiement (scan QR / lien)
  static const String payStepAmountTitle = "Combien payez-vous ?";
  static const String payStepAmountSub = "Vérifiez le montant et les canaux.";
  static const String payHeaderTitle = "Payer";
  static const String payHeaderSub = "Confirmez le paiement";
  static const String payContinueBtn = "Continuer vers le paiement";
  static const String payConfirmBtn = "Confirmer le paiement";
  static const String payConfirmTitle = "Vérification";
  static const String payConfirmSubtitle = "Confirmez votre paiement";
  static const String payProcessing = "Paiement en cours...";
  static const String paySuccessTitle = "Paiement en cours";
  static const String paySuccessMessage =
      "Votre paiement est en cours de traitement. Vous serez notifié dès que l'opération sera finalisée.";
  static const String payQuoteVerifyTitle = "Vérifiez le paiement";
  static const String payQuoteVerifySubtitle = "Dernière étape avant la confirmation";

  static const String backspaceSymbol = "⌫";

  static String feeOperatorWithRate(String operator) => "Frais $operator (3%)";
  static String recipientsFoundLabel(int count) =>
      "$count résultat${count > 1 ? 's' : ''}";
  static String accountsCountLabel(int count) =>
      "$count compte${count > 1 ? 's' : ''}";
  static String amountWithUnit(String amount) => "$amount XAF";
  static String feesEstimateLabel(String fees) => "≈ $fees XAF de frais";
}
