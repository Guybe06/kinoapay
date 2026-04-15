/// Chaînes globales partagées ; chaque feature complète via [feature]_strings.dart dans son dossier domain/.
abstract final class AppStrings {
  static const String appName = "kinoaPay";
  static const String currency = "XAF";
  static const String currencyLabel = "FCFA";
  static const String continueBtn = "Continuer";
  static const String cancelBtn = "Annuler";
  static const String confirmBtn = "Confirmer";
  static const String retryBtn = "Réessayer";
  static const String closeBtn = "Fermer";
  static const String loading = "Chargement...";
  static const String navDashboard = "Accueil";
  static const String navTransfer = "Envoyer";
  static const String navHistory = "Historique";
  static const String navProfile = "Profil";
  static const String headerContacts = "Contacts";
  static const String headerNotifications = "Notifications";
  static const String headerScan = "Scanner";
  static const String statusSuccess = "Réussi";
  static const String statusPending = "En attente";
  static const String statusFailed = "Échoué";
  static const String statusProcessing = "En cours";
  static const String errorFieldRequired = "Ce champ est obligatoire";
  static const String errorInvalidEmail = "L'adresse email n'est pas valide";
  static const String errorPasswordTooShort =
      "Le mot de passe doit contenir au moins 6 caractères";
  static const String errorInvalidPhone =
      "Le numéro de téléphone n'est pas valide";
  static const String errorInvalidAmount = "Le montant saisi est invalide";
  static const String errorAmountTooLow = "Le montant est trop faible";
  static const String errorNetwork =
      "Erreur de connexion. Vérifiez votre réseau.";
  static const String errorTimeout = "La requête a expiré. Réessayez.";
  static const String errorNoInternet = "Aucune connexion internet.";
  static const String errorServer = "Erreur serveur. Réessayez plus tard.";
  static const String errorServiceUnavailable =
      "Service temporairement indisponible.";
  static const String errorNotFound = "Ressource introuvable.";
  static const String errorConflict =
      "Conflit de données. Rechargez et réessayez.";
  static const String errorRateLimited =
      "Trop de tentatives. Attendez quelques instants.";
  static const String errorUnauthorized = "Session expirée. Reconnectez-vous.";
  static const String errorTokenExpired =
      "Votre session a expiré. Reconnectez-vous.";
  static const String errorTokenInvalid = "Token d'authentification invalide.";
  static const String errorSessionRevoked =
      "Session révoquée. Reconnectez-vous.";
  static const String errorLocalStorage =
      "Impossible d'enregistrer les données sur cet appareil. Réessayez ou redémarrez l'application.";
  static const String errorUnknown = "Une erreur inattendue s'est produite.";
  static const String errorCancelled = "Opération annulée.";

  static const String countryPickerTitle = "Choisir un pays";
  static const String countryPickerSearchHint = "Rechercher un pays...";
  static const String phoneFieldLabel = "Numéro de téléphone";
  static const String phoneFieldHint = "06 000 00 00";

  static String unknownRoute(String name) => "Route inconnue : $name";
}
