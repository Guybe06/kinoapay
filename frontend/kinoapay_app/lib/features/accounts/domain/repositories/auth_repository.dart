import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";

/// Définit le contrat d'accès aux données pour les services d'authentification.
abstract class AuthRepository {
  /// Authentifie l'utilisateur, persiste les tokens et retourne le profil.
  Future<UserAccount> signIn(String email, String password);

  /// Inscrit un nouvel utilisateur (crée le compte côté serveur / mock, sans persister de session).
  Future<UserAccount> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String countryCode,
    required String birthDate,
  });

  /// Envoie un code OTP au numéro fourni.
  Future<void> sendOtp(String phone, String countryCode);

  /// Vérifie le code OTP saisi, lève une exception si incorrect ou expiré.
  Future<void> verifyOtp(String phone, String countryCode, String code);

  /// Met fin à la session utilisateur active sans valeur de retour.
  Future<void> signOut();

  /// Récupère l'utilisateur actuellement connecté ou null si aucune session n'est active.
  Future<UserAccount?> getCurrentUser();

  /// Demande l'envoi d'un code de réinitialisation de mot de passe au contact fourni.
  /// @param contact  Email ou numéro de téléphone
  /// @param isEmail  true = email, false = téléphone
  Future<void> requestPasswordReset(String contact, {required bool isEmail});

  /// Vérifie le code OTP de réinitialisation, retourne un token temporaire pour le changement.
  /// @param contact  Email ou numéro de téléphone
  /// @param code     Code OTP saisi
  Future<String> verifyResetOtp(String contact, String code);

  /// Change le mot de passe avec le token temporaire obtenu après vérification OTP.
  /// @param resetToken    Token temporaire
  /// @param newPassword   Nouveau mot de passe
  Future<void> resetPassword(String resetToken, String newPassword);
}
