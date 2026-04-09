import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";
import "package:kinoapay_app/features/accounts/domain/repositories/auth_repository.dart";

/// Implémentation simulée du dépôt d'authentification pour les phases de test et de développement.
class MockAuthRepository implements AuthRepository {
  /// Simule une authentification par email et retourne un compte utilisateur factice ou lève une exception.
  @override
  Future<UserAccount> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == "test@kinoapay.com" && password == "password123") {
      return const UserAccount(
        id: "1",
        email: "test@kinoapay.com",
        fullName: "Utilisateur Test",
      );
    } else {
      throw Exception("Identifiants invalides");
    }
  }

  /// Simule la création d'un nouveau compte utilisateur et retourne l'entité UserAccount générée.
  @override
  Future<UserAccount> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    return UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      fullName: "Nouvel Utilisateur",
    );
  }

  /// Simule la déconnexion de l'utilisateur avec un délai de latence artificielle sans retour de valeur.
  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Simule la vérification de session et retourne null pour indiquer l'absence d'utilisateur connecté.
  @override
  Future<UserAccount?> getCurrentUser() async {
    return null;
  }
}
