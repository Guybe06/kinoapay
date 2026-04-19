/// Strings UI de la feature Envoi d'argent. Aucune chaîne littérale hors ce fichier.
abstract final class SendStrings {
  static const String title = "Envoyer";
  static const String pageTitle = "Envoyez simplement.";

  static const String stepRecipientTitle = "À qui envoyez-vous ?";
  static const String stepRecipientSub = "Par numéro ou identifiant Kinoa.";
  static const String stepAmountTitle = "Combien envoyez-vous ?";
  static const String stepAmountSub = "Choisissez le montant et les comptes.";

  static const String recipientHint = "Numéro sans code pays ou @ID Kinoa";
  static const String phoneHint = "Ex: 06 444 55 66";
  static const String idHint = "Identifiant Kinoa";
  static const String switchPhone = "Numéro de tél.";
  static const String switchId = "@ID_KINOAPAY";
  static const String idPrefix = "@";
  static const String recentContactsLabel = "CONTACTS RÉCENTS";
  static const String contactsBtn = "Tous les contacts";
  static const String kinoaUserTag = "kinoaPay";
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

  static const String confirmTitle = "Vérification";
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

  static const String errorUnsupportedCountry =
      "Ce numéro n'est pas supporté par kinoaPay pour le moment.";
  static const String errorNoAmount = "Entrez un montant valide.";
  static const String errorNoChannel = "Sélectionnez un canal de destination.";
  static const String errorNoSourceAccount =
      "Sélectionnez un compte à débiter.";
  static const String errorMinLength = "Entrez au moins 3 caractères";
  static const String errorMinPhoneLength = "Entrez au moins 4 chiffres";
  static const String errorUserNotFound = "Utilisateur non trouvé";

  static const String backspaceSymbol = "⌫";

  static String feeOperatorWithRate(String operator) => "Frais $operator (3%)";
  static String recipientsFoundLabel(int count) =>
      "$count résultat${count > 1 ? 's' : ''}";
  static String accountsCountLabel(int count) =>
      "$count compte${count > 1 ? 's' : ''}";
  static String amountWithUnit(String amount) => "$amount XAF";
  static String feesEstimateLabel(String fees) => "≈ $fees XAF de frais";
}
