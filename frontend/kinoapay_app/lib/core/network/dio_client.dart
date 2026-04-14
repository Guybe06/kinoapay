import "package:dio/dio.dart";
import "package:kinoapay_app/core/network/auth_interceptor.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";

/// Client HTTP centralisé : configure Dio avec les timeouts, headers et intercepteurs KinoaPay.
class DioClient {
  final Dio _dio;

  /// @param baseUrl  URL de base de l'API (ex: https://api.kinoaPay.com)
  /// @param storage  Service de stockage utilisé par l'intercepteur JWT
  DioClient({required String baseUrl, required SecureStorageService storage})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: const {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      ) {
    _dio.interceptors.add(AuthInterceptor(storage, _dio));
  }

  /// Retourne l'instance Dio configurée pour une utilisation dans les repositories.
  Dio get dio => _dio;
}
