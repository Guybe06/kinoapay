/// Codes d'erreur spécifiques au domaine d'authentification.
abstract final class AuthErrorCodes {
  // Inscription
  static const String emailAlreadyExists = "auth/email_already_exists";
  static const String weakPassword = "auth/weak_password";
  static const String invalidEmail = "auth/invalid_email";
  // OTP
  static const String otpInvalid = "auth/otp_invalid";
  static const String otpExpired = "auth/otp_expired";
  // Connexion
  static const String invalidCredentials = "auth/invalid_credentials";
  static const String accountDisabled = "auth/account_disabled";
  static const String tooManyAttempts = "auth/too_many_attempts";
}
