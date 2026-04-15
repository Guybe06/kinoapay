/// Chaînes de l'interface Auth (connexion, inscription, réinitialisation).
abstract final class AuthStrings {
  static const String phoneLabel = "Numéro de téléphone";
  static const String emailLabel = "Adresse email";
  static const String passwordLabel = "Mot de passe";
  static const String submitBtn = "Continuer";

  static const String signinTitle = "Connexion";
  static const String signinSubtitle = "Utilisez votre compte kinoaPay";
  static const String signinForgotPass = "Mot de passe oublié ?";
  static const String signinNoAccount = "Pas encore de compte ?";
  static const String signinSignupLink = "S'inscrire";

  static const String errorInvalidCredentials =
      "Email ou mot de passe incorrect.";
  static const String errorEmailAlreadyExists =
      "Cette adresse email est déjà utilisée.";
  static const String errorAccountDisabled =
      "Ce compte a été suspendu. Contactez le support.";
  static const String errorTooManyAttempts =
      "Trop de tentatives. Réessayez dans quelques minutes.";

  static const String signinSuccess = "Connexion réussie !";
  static const String signupSuccess = "Compte créé avec succès !";

  static const String signupStep1Title = "Votre identité";
  static const String signupStep1Subtitle =
      "Ces informations nous permettent de sécuriser votre compte";
  static const String firstNameLabel = "Prénom";
  static const String lastNameLabel = "Nom";
  static const String birthDateLabel = "Date de naissance";
  static const String birthDateHint = "JJ/MM/AAAA";

  static const String signupStep2Title = "Vos identifiants";
  static const String signupStep2Subtitle =
      "Vous utiliserez ceci pour vous connecter";
  static const String signupHaveAccount = "Déjà un compte ?";
  static const String signupSigninLink = "Se connecter";
  static const String signupTerms =
      "En continuant, vous acceptez nos conditions d'utilisation.";

  static const String otpTitle = "Vérifiez votre numéro";
  static const String otpBody = "Entrez le code à 6 chiffres envoyé au";
  static const String otpResend = "Renvoyer le code";
  static const String otpResendIn = "Renvoyer dans";
  static const String otpInvalid = "Code incorrect. Vérifiez et réessayez.";
  static const String otpExpired = "Code expiré. Demandez un nouveau code.";

  static const String resetTitle = "Réinitialiser";
  static const String resetSubtitle =
      "Choisissez comment recevoir votre code de vérification";
  static const String resetViaEmail = "Par email";
  static const String resetViaPhone = "Par téléphone";
  static const String resetEmailHint = "Votre adresse email";
  static const String resetPhoneHint = "Votre numéro de téléphone";
  static const String resetSendCode = "Envoyer le code";
  static const String resetOtpTitle = "Vérification";
  static const String resetOtpBody = "Entrez le code à 6 chiffres envoyé à";
  static const String resetNewPassTitle = "Nouveau mot de passe";
  static const String resetNewPassSubtitle =
      "Créez un mot de passe sécurisé pour votre compte";
  static const String resetNewPassLabel = "Nouveau mot de passe";
  static const String resetConfirmPassLabel = "Confirmer le mot de passe";
  static const String resetSuccess = "Mot de passe modifié avec succès !";
  static const String resetPassMismatch =
      "Les mots de passe ne correspondent pas.";
  static const String resetRateLimited = "Trop de tentatives. Réessayez dans";
}
