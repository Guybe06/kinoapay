import "dart:convert";

import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/accounts/domain/auth_error_codes.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";
import "package:kinoapay_app/features/accounts/domain/repositories/auth_repository.dart";

/// Implémentation mock du dépôt d'authentification.
/// Simule un backend réel avec stockage en mémoire, mêmes contrats et mêmes erreurs typées.
class MockAuthRepository implements AuthRepository {
  static final Map<String, _MockCredentials> _store = {
    "test@kinoapay.com": _MockCredentials(
      password: "password123",
      account: const UserAccount(id: "seed_1", email: "test@kinoapay.com", fullName: "Compte test kinoaPay"),
    ),
  };

  static const String _mockAccessPrefix = "mock_access_";
  static const String _mockRefreshPrefix = "mock_refresh_";

  static UserAccount? _session;

  final SecureStorageService _storage;

  MockAuthRepository({required SecureStorageService storage}) : _storage = storage;

  Map<String, dynamic> _userToMap(UserAccount u) => {
        "id": u.id,
        "email": u.email,
        "fullName": u.fullName,
        "firstName": u.firstName,
        "lastName": u.lastName,
        "phone": u.phone,
        "countryCode": u.countryCode,
        "birthDate": u.birthDate,
        "kycVerified": u.kycVerified,
      };

  UserAccount _userFromMap(Map<String, dynamic> d) => UserAccount(
        id: d["id"].toString(),
        email: d["email"] as String,
        fullName: d["fullName"] as String?,
        firstName: d["firstName"] as String?,
        lastName: d["lastName"] as String?,
        phone: d["phone"] as String?,
        countryCode: d["countryCode"] as String?,
        birthDate: d["birthDate"] as String?,
        kycVerified: (d["kycVerified"] as bool?) ?? false,
      );

  /// Persiste toujours access + refresh tokens et le profil utilisateur.
  Future<void> _persistSession(UserAccount account) async {
    await _storage.saveTokens(
      accessToken: "$_mockAccessPrefix${account.id}",
      refreshToken: "$_mockRefreshPrefix${account.id}_${DateTime.now().millisecondsSinceEpoch}",
    );
    await _storage.saveUserData(jsonEncode(_userToMap(account)));
  }

  @override
  Future<UserAccount> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final entry = _store[email.trim().toLowerCase()];

    if (entry == null || entry.password != password) {
      throw AppException(
        message: AuthStrings.errorInvalidCredentials,
        code: AuthErrorCodes.invalidCredentials,
        statusCode: 401,
      );
    }

    _session = entry.account;
    await _persistSession(entry.account);
    return entry.account;
  }

  @override
  Future<UserAccount> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String countryCode,
    required String birthDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final key = email.trim().toLowerCase();

    if (_store.containsKey(key)) {
      throw AppException(
        message: AuthStrings.errorEmailAlreadyExists,
        code: AuthErrorCodes.emailAlreadyExists,
        statusCode: 409,
      );
    }

    final account = UserAccount(
      id: "mock_${DateTime.now().millisecondsSinceEpoch}",
      email: key,
      fullName: "$firstName $lastName",
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      countryCode: countryCode,
      birthDate: birthDate,
    );

    _store[key] = _MockCredentials(password: password, account: account);
    return account;
  }

  static const String _mockOtpCode = "123456";

  @override
  Future<void> sendOtp(String phone, String countryCode) async {
    await Future.delayed(const Duration(milliseconds: 1200));
  }

  @override
  Future<void> verifyOtp(String phone, String countryCode, String code) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (code != _mockOtpCode) {
      throw AppException(
        message: AuthStrings.otpInvalid,
        code: AuthErrorCodes.otpInvalid,
        statusCode: 422,
      );
    }
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _session = null;
    await _storage.clearSession();
  }

  @override
  Future<UserAccount?> getCurrentUser() async {
    final token = await _storage.getToken();
    final raw = await _storage.getUserData();
    if (token == null || token.isEmpty || raw == null) return _session;
    try {
      return _userFromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return _session;
    }
  }

  // ── Réinitialisation mot de passe ──────────────────────────────────────────

  static const String _mockResetToken = "mock_reset_token_valid";

  @override
  Future<void> requestPasswordReset(String contact, {required bool isEmail}) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final key = contact.trim().toLowerCase();
    if (isEmail && !_store.containsKey(key)) {
      throw AppException(
        message: "Aucun compte associé à cette adresse.",
        code: AuthErrorCodes.invalidCredentials,
        statusCode: 404,
      );
    }
  }

  @override
  Future<String> verifyResetOtp(String contact, String code) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (code != _mockOtpCode) {
      throw AppException(
        message: AuthStrings.otpInvalid,
        code: AuthErrorCodes.otpInvalid,
        statusCode: 422,
      );
    }
    return _mockResetToken;
  }

  @override
  Future<void> resetPassword(String resetToken, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (resetToken != _mockResetToken) {
      throw AppException.unauthorized();
    }
    // En mock : met à jour le premier compte trouvé (simulation).
    final firstKey = _store.keys.firstOrNull;
    if (firstKey != null) {
      final old = _store[firstKey]!;
      _store[firstKey] = _MockCredentials(password: newPassword, account: old.account);
    }
  }
}

class _MockCredentials {
  final String password;
  final UserAccount account;
  const _MockCredentials({required this.password, required this.account});
}
