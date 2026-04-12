/// Chaînes de l'interface Auth (connexion et inscription).
class AuthStrings {
  // Champs communs
  static const String phoneLabel = "Numéro de téléphone";
  static const String emailLabel = "Adresse email";
  static const String passwordLabel = "Mot de passe";
  static const String submitBtn = "Continuer";
  // Connexion
  static const String signinTitle = "Connexion";
  static const String signinSubtitle = "Utilisez votre compte KinoaPay";
  static const String signinForgotPass = "Mot de passe oublié ?";
  static const String signinNoAccount = "Pas encore de compte ?";
  static const String signinSignupLink = "S'inscrire";
  // Erreurs
  static const String errorInvalidCredentials = "Email ou mot de passe incorrect.";
  static const String errorEmailAlreadyExists = "Cette adresse email est déjà utilisée.";
  static const String errorAccountDisabled = "Ce compte a été suspendu. Contactez le support.";
  static const String errorTooManyAttempts = "Trop de tentatives. Réessayez dans quelques minutes.";
  // Retours
  static const String signinSuccess = "Connexion réussie !";
  static const String signupSuccess = "Compte créé avec succès !";
  // Inscription — étape 1 (identité)
  static const String signupStep1Title = "Votre identité";
  static const String signupStep1Subtitle = "Ces informations nous permettent de sécuriser votre compte";
  static const String firstNameLabel = "Prénom";
  static const String lastNameLabel = "Nom";
  static const String birthDateLabel = "Date de naissance";
  static const String birthDateHint = "JJ/MM/AAAA";
  // Inscription — étape 2 (identifiants)
  static const String signupStep2Title = "Vos identifiants";
  static const String signupStep2Subtitle = "Vous utiliserez ceci pour vous connecter";
  static const String signupHaveAccount = "Déjà un compte ?";
  static const String signupSigninLink = "Se connecter";
  static const String signupTerms = "En continuant, vous acceptez nos conditions d'utilisation.";
  // Vérification OTP
  static const String otpTitle = "Vérifiez votre numéro";
  static const String otpBody = "Entrez le code à 6 chiffres envoyé au";
  static const String otpResend = "Renvoyer le code";
  static const String otpResendIn = "Renvoyer dans";
  static const String otpInvalid = "Code incorrect. Vérifiez et réessayez.";
  static const String otpExpired = "Code expiré. Demandez un nouveau code.";
  // Onboarding post-inscription
  static const String celebrationTitle = "Votre compte est créé";
  static const String celebrationSubtitlePrefix = "Bienvenue,";
  static const String celebrationBody = "Vous pouvez maintenant envoyer et recevoir de l'argent en toute simplicité.";
  static const String kycTitle = "Vérifiez votre identité";
  static const String kycSubtitle = "Quelques minutes suffisent pour débloquer toutes vos fonctionnalités";
  static const String kycBenefitTransfer = "Envoyez de l'argent en quelques secondes";
  static const String kycBenefitMobile = "Recevez des paiements de n'importe où";
  static const String kycBenefitSecurity = "Votre compte est vérifié et sécurisé";
  static const String kycVerifyNow = "Vérifier maintenant";
  static const String kycLater = "Plus tard";
  static const String kycLaterNote = "Certaines fonctionnalités resteront limitées.";
}
