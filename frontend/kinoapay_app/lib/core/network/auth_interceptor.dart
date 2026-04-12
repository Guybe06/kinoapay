import "package:dio/dio.dart";
import "package:kinoapay_app/core/errors/kinoa_exception.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";

/// Intercepteur Dio : injecte le token JWT et traduit les erreurs HTTP en KinoaException.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;

  /// @param storage  Service utilisé pour lire le token JWT stocké
  const AuthInterceptor(this._storage);

  /// Ajoute le header Authorization si un token est disponible.
  /// @param options  Options de la requête en cours
  /// @param handler  Handler permettant de continuer ou bloquer la requête
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }

  /// Traduit les erreurs Dio en KinoaException selon le type et le code HTTP.
  /// @param err      Erreur Dio reçue
  /// @param handler  Handler permettant de rejeter avec l'exception typée
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _toKinoaException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        message: exception.message,
      ),
    );
  }

  /// Convertit une DioException en KinoaException selon son type et son status HTTP.
  /// @param err  Erreur Dio à convertir
  /// @return     KinoaException typée correspondante
  KinoaException _toKinoaException(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return KinoaException.timeout();
    }

    if (err.type == DioExceptionType.connectionError) {
      return KinoaException.network();
    }

    final status = err.response?.statusCode;
    if (status == null) return KinoaException.unknown();

    return switch (status) {
      401 => KinoaException.unauthorized(),
      404 => KinoaException.notFound(),
      409 => KinoaException.conflict(),
      429 => KinoaException.rateLimited(),
      503 => KinoaException.serviceUnavailable(),
      _ when status >= 500 => KinoaException.serverError(),
      _ => KinoaException.unknown(),
    };
  }
}
