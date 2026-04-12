import "dart:convert";
import "package:dio/dio.dart";
import "package:kinoapay_app/core/errors/kinoa_exception.dart";
import "package:kinoapay_app/core/network/dio_client.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";
import "package:kinoapay_app/features/accounts/domain/repositories/auth_repository.dart";

/// Implémentation du dépôt d'authentification via l'API REST KinoaGate.
class HttpAuthRepository implements AuthRepository {
  final DioClient _dioClient;
  final SecureStorageService _secureStorage;

  const HttpAuthRepository({
    required DioClient dioClient,
    required SecureStorageService secureStorage,
  })  : _dioClient = dioClient,
        _secureStorage = secureStorage;

  @override
  Future<UserAccount> signIn(String email, String password, {bool rememberMe = true}) async {
    try {
      final response = await _dioClient.dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );
      return _parseAndPersist(response.data, rememberMe: rememberMe);
    } on KinoaException {
      rethrow;
    } on DioException catch (e) {
      throw _fromDio(e);
    } catch (_) {
      throw KinoaException.unknown();
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
        "/auth/register",
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
      return _parseAndPersist(response.data);
    } on KinoaException {
      rethrow;
    } on DioException catch (e) {
      throw _fromDio(e);
    } catch (_) {
      throw KinoaException.unknown();
    }
  }

  @override
  Future<void> signOut() => _secureStorage.clearSession();

  @override
  Future<UserAccount?> getCurrentUser() async {
    final token = await _secureStorage.getToken();
    final raw = await _secureStorage.read("user_data");
    if (token == null || raw == null) return null;
    try {
      return _userFromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // Parse API response, persist user data, save token only if rememberMe is true.
  Future<UserAccount> _parseAndPersist(Map<String, dynamic> data, {bool rememberMe = true}) async {
    final token = data["token"] as String;
    final userData = data["user"] as Map<String, dynamic>;
    if (rememberMe) await _secureStorage.saveToken(token);
    await _secureStorage.write("user_data", jsonEncode(userData));
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

  // Map DioException status codes to typed KinoaException.
  KinoaException _fromDio(DioException e) {
    final status = e.response?.statusCode;
    return switch (status) {
      401 => KinoaException.unauthorized(),
      409 => KinoaException.conflict(),
      429 => KinoaException.rateLimited(),
      503 => KinoaException.serviceUnavailable(),
      null => e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout
          ? KinoaException.timeout()
          : KinoaException.noInternet(),
      _ => status >= 500 ? KinoaException.serverError() : KinoaException.unknown(),
    };
  }
}
