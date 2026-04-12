import "package:kinoapay_app/core/errors/kinoa_exception.dart";
import "package:kinoapay_app/features/accounts/domain/auth_error_codes.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";
import "package:kinoapay_app/features/accounts/domain/repositories/auth_repository.dart";

/// Implémentation mock du dépôt d'authentification.
/// Simule un backend réel avec stockage en mémoire, mêmes contrats et mêmes erreurs typées.
class MockAuthRepository implements AuthRepository {
  // Utilisateurs enregistrés en mémoire (email → credentials + compte).
  // Pré-seeded avec un compte de test. Réinitialisé à chaque cold restart.
  static final Map<String, _MockCredentials> _store = {
    "test@kinoapay.com": _MockCredentials(
      password: "password123",
      account: const UserAccount(id: "seed_1", email: "test@kinoapay.com", fullName: "Compte Test KinoaPay"),
    ),
  };

  static UserAccount? _session;

  @override
  Future<UserAccount> signIn(String email, String password, {bool rememberMe = true}) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final entry = _store[email.trim().toLowerCase()];

    if (entry == null || entry.password != password) {
      throw KinoaException(
        message: AuthStrings.errorInvalidCredentials,
        code: AuthErrorCodes.invalidCredentials,
        statusCode: 401,
      );
    }

    if (rememberMe) _session = entry.account;
    return entry.account;
  }

  @override
  Future<UserAccount> signUp(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final key = email.trim().toLowerCase();

    if (_store.containsKey(key)) {
      throw KinoaException(
        message: AuthStrings.errorEmailAlreadyExists,
        code: AuthErrorCodes.emailAlreadyExists,
        statusCode: 409,
      );
    }

    final account = UserAccount(
      id: "mock_${DateTime.now().millisecondsSinceEpoch}",
      email: key,
      fullName: "Utilisateur KinoaPay",
    );

    _store[key] = _MockCredentials(password: password, account: account);
    _session = account;
    return account;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _session = null;
  }

  @override
  Future<UserAccount?> getCurrentUser() async => _session;
}

class _MockCredentials {
  final String password;
  final UserAccount account;
  const _MockCredentials({required this.password, required this.account});
}
