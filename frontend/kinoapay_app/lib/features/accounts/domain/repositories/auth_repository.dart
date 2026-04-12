import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";

/// Définit le contrat d'accès aux données pour les services d'authentification.
abstract class AuthRepository {
  /// Authentifie l'utilisateur et retourne son compte ou lève une exception en cas d'échec.
  Future<UserAccount> signIn(String email, String password, {bool rememberMe = true});

  /// Inscrit un nouvel utilisateur avec ses informations personnelles et retourne le compte créé.
  Future<UserAccount> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String countryCode,
    required String birthDate,
  });

  /// Met fin à la session utilisateur active sans valeur de retour.
  Future<void> signOut();

  /// Récupère l'utilisateur actuellement connecté ou null si aucune session n'est active.
  Future<UserAccount?> getCurrentUser();
}
