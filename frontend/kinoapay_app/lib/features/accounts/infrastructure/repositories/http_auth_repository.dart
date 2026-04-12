import "dart:convert";
import "package:dio/dio.dart";
import "package:kinoapay_app/core/network/dio_client.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";
import "package:kinoapay_app/features/accounts/domain/repositories/auth_repository.dart";

/// Implémentation du dépôt d'authentification utilisant l'API REST via Dio.
class HttpAuthRepository implements AuthRepository {
  final DioClient _dioClient;
  final SecureStorageService _secureStorage;

  const HttpAuthRepository({
    required DioClient dioClient,
    required SecureStorageService secureStorage,
  })  : _dioClient = dioClient,
        _secureStorage = secureStorage;

  /// Tente d'authentifier l'utilisateur avec ses identifiants et gère la persistance de la session.
  @override
  Future<UserAccount> signIn(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        "/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      final token = response.data["token"];
      final userData = response.data["user"];

      await _secureStorage.saveToken(token);
      await _secureStorage.write("user_data", jsonEncode(userData));

      return UserAccount(
        id: userData["id"].toString(),
        email: userData["email"],
        fullName: userData["fullName"],
      );
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Erreur d'authentification";
      throw Exception(message);
    } catch (e) {
      throw Exception("Une erreur inattendue est survenue");
    }
  }

  /// Inscrit un nouvel utilisateur et traite la réponse de création de compte de l'API.
  @override
  Future<UserAccount> signUp(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        "/auth/register",
        data: {
          "email": email,
          "password": password,
        },
      );

      final token = response.data["token"];
      final userData = response.data["user"];

      await _secureStorage.saveToken(token);
      await _secureStorage.write("user_data", jsonEncode(userData));

      return UserAccount(
        id: userData["id"].toString(),
        email: userData["email"],
        fullName: userData["fullName"],
      );
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Erreur lors de l'inscription";
      throw Exception(message);
    } catch (e) {
      throw Exception("Une erreur inattendue est survenue");
    }
  }

  /// Révoque la session locale et nettoie les données sécurisées de l'utilisateur.
  @override
  Future<void> signOut() async {
    await _secureStorage.clearAll();
  }

  /// Charge les données utilisateur persistées localement pour restaurer la session active.
  @override
  Future<UserAccount?> getCurrentUser() async {
    final token = await _secureStorage.getToken();
    final userDataString = await _secureStorage.read("user_data");

    if (token == null || userDataString == null) {
      return null;
    }

    try {
      final userData = jsonDecode(userDataString);
      return UserAccount(
        id: userData["id"].toString(),
        email: userData["email"],
        fullName: userData["fullName"],
      );
    } catch (_) {
      return null;
    }
  }
}
