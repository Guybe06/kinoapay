import "package:kinoapay_app/core/errors/kinoa_exception.dart";
import "package:kinoapay_app/features/accounts/domain/auth_error_codes.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";
import "package:kinoapay_app/features/accounts/domain/repositories/auth_repository.dart";

/// Implémentation simulée du dépôt d'authentification pour le développement et les tests.
class MockAuthRepository implements AuthRepository {
  @override
  Future<UserAccount> signIn(String email, String password, {bool rememberMe = true}) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == "test@kinoapay.com" && password == "password123") {
      return const UserAccount(id: "1", email: "test@kinoapay.com", fullName: "Utilisateur Test");
    }

    throw KinoaException(
      message: AuthStrings.errorInvalidCredentials,
      code: AuthErrorCodes.invalidCredentials,
      statusCode: 401,
    );
  }

  @override
  Future<UserAccount> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    return UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      fullName: "Nouvel Utilisateur",
    );
  }

  @override
  Future<void> signOut() async => Future.delayed(const Duration(milliseconds: 300));

  @override
  Future<UserAccount?> getCurrentUser() async => null;
}
