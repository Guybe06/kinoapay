/// Strings UI de la feature Envoi d'argent. Aucune chaîne littérale hors ce fichier.
abstract final class SendStrings {
  static const String title = "Envoyer";
  static const String subtitle = "Transférez des fonds instantanément.";
  static const String pageTitle = "Envoyez simplement.";

  static const String stepAmountTitle = "Combien voulez-vous envoyer ?";
  static const String stepAmountSub = "Saisissez le montant du transfert.";
  static const String stepMethodTitle = "Comment trouver le destinataire ?";
  static const String stepRecipientTitle = "À qui envoyez-vous ?";
  static const String stepRecipientSub =
      "Entrez le numéro ou l'identifiant du destinataire.";
  static const String stepChannelTitle = "Choisissez les comptes.";
  static const String stepChannelSub =
      "Compte à débiter et compte destinataire.";

  static const String methodSearchTitle = "Rechercher";
  static const String methodSearchSubtitle = "Par numéro ou @ID Kinoa";
  static const String methodContactsTitle = "Mes contacts";
  static const String methodContactsSubtitle = "Choisir parmi mes contacts";

  static const String searchBtn = "Rechercher";
  static const String simulateBtn = "Simuler les frais";
  static const String continueBtn = "Continuer";
  static const String modifyBtn = "Modifier";
  static const String cancelBtn = "Annuler";
  static const String confirmBtn = "Confirmer l'envoi";
  static const String confirmShortBtn = "Confirmer";

  static const String amountLabel = "Montant à envoyer";
  static const String amountDisplayLabel = "MONTANT";
  static const String amountUnit = "XAF";

  static const String recipientLabel = "À qui ?";
  static const String recipientHint = "Numéro sans code pays ou @ID Kinoa";

  static const String dropdownHint = "Sélectionner";
  static const String chooseChannel = "COMPTE DESTINATAIRE";
  static const String chooseSource = "COMPTE À DÉBITER";
  static const String sourceLabel = "Depuis mon compte";
  static const String destLabel = "Vers le compte";

  static const String simulationTitle = "Simulation des frais";
  static const String simulationSubtitle = "Montants en XAF";
  static const String simAmountLabel = "Montant";
  static const String simKinoaFeeLabel = "Frais Kinoa (1%)";
  static const String simTotalLabel = "Total estimé";

  static const String confirmTitle = "Vérification";
  static const String confirmToLabel = "Vers";
  static const String confirmTotalLabel = "Total";
  static const String feeKinoa = "Frais Kinoa";
  static const String feeOperator = "Frais Opérateur";
  static const String totalDebited = "Total à débiter";

  static const String processing = "Traitement sécurisé...";

  static const String errorFields =
      "Veuillez remplir tous les champs correctement.";
  static const String errorNoAmount = "Entrez un montant valide.";
  static const String errorNoChannel = "Sélectionnez un canal de destination.";
  static const String errorNoSourceAccount =
      "Sélectionnez un compte à débiter.";
  static const String errorMinLength = "Entrez au moins 3 caractères";
  static const String errorUserNotFound = "Utilisateur non trouvé";

  static const String backspaceSymbol = "⌫";

  static String feeOperatorWithRate(String operator) => "Frais $operator (3%)";
  static String recipientsFoundLabel(int count) =>
      "$count contact${count > 1 ? 's' : ''} trouvé${count > 1 ? 's' : ''}";
  static String accountsCountLabel(int count) =>
      "$count compte${count > 1 ? 's' : ''}";
  static String amountWithUnit(String amount) => "$amount XAF";
}
