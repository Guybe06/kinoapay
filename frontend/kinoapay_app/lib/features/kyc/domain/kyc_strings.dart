/// Toutes les chaînes UI de la feature KYC. Aucune chaîne littérale hors ce fichier.
abstract final class KycStrings {
  // Navigation
  static const String backLabel = "Retour";
  static const String title = "Vérification d'identité";
  static const String headerSubtitle = "Complétez votre dossier KYC";

  // Étape 1 — type de document
  static const String stepDocTitle = "Choisissez votre document";
  static const String stepDocSubtitle =
      "Sélectionnez le document d'identité que vous souhaitez utiliser.";
  static const String docCni = "Carte Nationale d'Identité";
  static const String docPassport = "Passeport";
  static const String docLicense = "Permis de conduire";
  static const String docCniSub = "Délivrée par votre pays de résidence";
  static const String docPassportSub = "Passeport en cours de validité";
  static const String docLicenseSub = "Permis de conduire en cours de validité";
  static const String continueBtn = "Continuer";

  // Étape 2 — photo du document
  static const String stepPhotoTitle = "Photo de votre document";
  static const String stepPhotoSubtitle =
      "Prenez une photo claire du recto de votre document.";
  static const String photoHint =
      "Assurez-vous que toutes les informations sont lisibles.";
  static const String takePhotoBtn = "Prendre une photo";
  static const String retakePhotoBtn = "Reprendre";
  static const String galleryBtn = "Choisir depuis la galerie";

  // Étape 3 — selfie
  static const String stepSelfieTitle = "Votre selfie";
  static const String stepSelfieSubtitle =
      "Prenez une photo de votre visage pour confirmer votre identité.";
  static const String selfieHint =
      "Regardez bien la caméra, visage entier, bonne lumière.";
  static const String takeSelfieBtn = "Prendre le selfie";
  static const String retakeSelfieBtn = "Reprendre";

  // Étape 4 — soumis
  static const String stepSubmittedTitle = "Dossier envoyé !";
  static const String stepSubmittedSubtitle =
      "Votre dossier est en cours de vérification. Vous recevrez une notification dans les 24 à 48 heures.";
  static const String submittedNote =
      "En attendant, vous pouvez continuer à utiliser kinoaPay normalement.";
  static const String backHomeBtn = "Retour à l'accueil";

  // Erreurs
  static const String errorPermission =
      "Accès à la caméra refusé. Autorisez l'accès dans les paramètres.";
  static const String errorPhotoMissing = "Veuillez ajouter la photo du document.";
  static const String errorSelfieMissing = "Veuillez ajouter votre selfie.";
}
