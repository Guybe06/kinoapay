/// Chaînes globales de l'application KinoaPay.
/// Chaque feature complète ces chaînes dans son fichier [feature]_strings.dart situé dans son dossier domain/.
class KinoaStrings {
  // Application
  static const String appName = "KinoaPay";
  static const String currency = "XAF";
  static const String currencyLabel = "FCFA";
  // Boutons génériques
  static const String continueBtn = "Continuer";
  static const String cancelBtn = "Annuler";
  static const String confirmBtn = "Confirmer";
  static const String retryBtn = "Réessayer";
  static const String closeBtn = "Fermer";
  static const String loading = "Chargement...";
  // Navigation (onglets)
  static const String navDashboard = "Accueil";
  static const String navTransfer = "Envoyer";
  static const String navHistory = "Historique";
  static const String navProfile = "Profil";
  // Header
  static const String headerContacts = "Contacts";
  static const String headerNotifications = "Notifications";
  static const String headerScan = "Scanner";
  // Statuts transaction
  static const String statusSuccess = "Réussi";
  static const String statusPending = "En attente";
  static const String statusFailed = "Échoué";
  static const String statusProcessing = "En cours";
  // Erreurs de validation
  static const String errorFieldRequired = "Ce champ est obligatoire";
  static const String errorInvalidEmail = "L'adresse email n'est pas valide";
  static const String errorPasswordTooShort = "Le mot de passe doit contenir au moins 8 caractères";
  static const String errorInvalidPhone = "Le numéro de téléphone n'est pas valide";
  static const String errorInvalidAmount = "Le montant saisi est invalide";
  static const String errorAmountTooLow = "Le montant est trop faible";
  // Erreurs réseau
  static const String errorNetwork = "Erreur de connexion. Vérifiez votre réseau.";
  static const String errorTimeout = "La requête a expiré. Réessayez.";
  static const String errorNoInternet = "Aucune connexion internet.";
  static const String errorServer = "Erreur serveur. Réessayez plus tard.";
  static const String errorServiceUnavailable = "Service temporairement indisponible.";
  static const String errorNotFound = "Ressource introuvable.";
  static const String errorConflict = "Conflit de données. Rechargez et réessayez.";
  static const String errorRateLimited = "Trop de tentatives. Attendez quelques instants.";
  // Erreurs d'authentification
  static const String errorUnauthorized = "Session expirée. Reconnectez-vous.";
  static const String errorTokenExpired = "Votre session a expiré. Reconnectez-vous.";
  static const String errorTokenInvalid = "Token d'authentification invalide.";
  static const String errorSessionRevoked = "Session révoquée. Reconnectez-vous.";
  // Erreurs génériques
  static const String errorUnknown = "Une erreur inattendue s'est produite.";
  static const String errorCancelled = "Opération annulée.";
}
