import "dart:convert";
import "package:dio/dio.dart";
import "package:kinoapay_app/core/constants/api_paths.dart";
import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/core/network/dio_client.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";
import "package:kinoapay_app/features/accounts/domain/repositories/auth_repository.dart";

/// Implémentation du dépôt d'authentification via l'API REST du backend.
class HttpAuthRepository implements AuthRepository {
  final DioClient _dioClient;
  final SecureStorageService _secureStorage;

  const HttpAuthRepository({
    required DioClient dioClient,
    required SecureStorageService secureStorage,
  })  : _dioClient = dioClient,
        _secureStorage = secureStorage;

  @override
  Future<UserAccount> signIn(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        ApiPaths.signin,
        data: {"email": email, "password": password},
      );
      return _parseAndPersist(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw _fromDio(e);
    } catch (_) {
      throw AppException.unknown();
    }
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
    try {
      final response = await _dioClient.dio.post(
        ApiPaths.signup,
        data: {
          "email": email,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
          "phone": phone,
          "countryCode": countryCode,
          "birthDate": birthDate,
        },
      );
      final userData = (response.data as Map<String, dynamic>)["user"] as Map<String, dynamic>;
      return _userFromMap(userData);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw _fromDio(e);
    } catch (_) {
      throw AppException.unknown();
    }
  }

  @override
  Future<void> sendOtp(String phone, String countryCode) async {
    try {
      await _dioClient.dio.post("/auth/otp/send", data: {"phone": phone, "countryCode": countryCode});
    } on DioException catch (e) {
      throw _fromDio(e);
    } catch (_) {
      throw AppException.unknown();
    }
  }

  @override
  Future<void> verifyOtp(String phone, String countryCode, String code) async {
    try {
      await _dioClient.dio.post("/auth/otp/verify", data: {"phone": phone, "countryCode": countryCode, "code": code});
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw _fromDio(e);
    } catch (_) {
      throw AppException.unknown();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dioClient.dio.post(ApiPaths.signout);
    } catch (_) {
      // Best effort : on nettoie la session même si le serveur ne répond pas.
    }
    await _secureStorage.clearSession();
  }

  @override
  Future<UserAccount?> getCurrentUser() async {
    final token = await _secureStorage.getToken();
    final raw = await _secureStorage.getUserData();
    if (token == null || raw == null) return null;
    try {
      return _userFromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Parse la réponse login, persiste access + refresh tokens et le profil.
  Future<UserAccount> _parseAndPersist(Map<String, dynamic> data) async {
    final accessToken = data["accessToken"] as String;
    final refreshToken = data["refreshToken"] as String;
    final userData = data["user"] as Map<String, dynamic>;
    await _secureStorage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    await _secureStorage.saveUserData(jsonEncode(userData));
    return _userFromMap(userData);
  }

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

  // ── Réinitialisation mot de passe ──────────────────────────────────────────

  @override
  Future<void> requestPasswordReset(String contact, {required bool isEmail}) async {
    try {
      await _dioClient.dio.post("/auth/password/request", data: {"contact": contact, "type": isEmail ? "email" : "phone"});
    } on DioException catch (e) {
      throw _fromDio(e);
    } catch (_) {
      throw AppException.unknown();
    }
  }

  @override
  Future<String> verifyResetOtp(String contact, String code) async {
    try {
      final response = await _dioClient.dio.post("/auth/password/verify", data: {"contact": contact, "code": code});
      return (response.data as Map<String, dynamic>)["resetToken"] as String;
    } on DioException catch (e) {
      throw _fromDio(e);
    } catch (_) {
      throw AppException.unknown();
    }
  }

  @override
  Future<void> resetPassword(String resetToken, String newPassword) async {
    try {
      await _dioClient.dio.post("/auth/password/reset", data: {"resetToken": resetToken, "password": newPassword});
    } on DioException catch (e) {
      throw _fromDio(e);
    } catch (_) {
      throw AppException.unknown();
    }
  }

  AppException _fromDio(DioException e) {
    final status = e.response?.statusCode;
    return switch (status) {
      401 => AppException.unauthorized(),
      409 => AppException.conflict(),
      429 => AppException.rateLimited(),
      503 => AppException.serviceUnavailable(),
      null => e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout
          ? AppException.timeout()
          : AppException.noInternet(),
      _ => status >= 500 ? AppException.serverError() : AppException.unknown(),
    };
  }
}
