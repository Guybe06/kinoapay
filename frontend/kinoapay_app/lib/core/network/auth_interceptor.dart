import "dart:async";
import "package:dio/dio.dart";
import "package:kinoapay_app/core/constants/api_paths.dart";
import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";

/// Intercepteur Dio : injecte le token JWT, rafraîchit automatiquement sur 401
/// (refresh token rotation avec mutex) et traduit les erreurs HTTP en AppException.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Dio _dio;

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  /// @param storage  Service de stockage des tokens
  /// @param dio      Instance Dio pour POST [ApiPaths.refresh] sans réentrer dans l'intercepteur de façon circulaire
  AuthInterceptor(this._storage, this._dio);

  /// Ajoute le header Authorization si un access token est disponible.
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }

  /// Sur 401 (sauf /refresh lui-même) : tente un refresh, rejoue la requête, ou déconnecte.
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final path = err.requestOptions.path;

    if (status != 401 || path == ApiPaths.refresh) {
      handler.reject(_wrap(err));
      return;
    }

    try {
      final newToken = await _tryRefresh();
      if (newToken != null) {
        final retryOpts = err.requestOptions
          ..headers["Authorization"] = "Bearer $newToken";
        final response = await _dio.fetch(retryOpts);
        handler.resolve(response);
        return;
      }
    } catch (_) {}

    await _storage.clearSession();
    handler.reject(_wrap(err));
  }

  /// Rafraîchit le couple access/refresh de façon exclusive pour les appels concurrents.
  /// @return le nouvel access token ou null si échec ou refresh absent
  Future<String?> _tryRefresh() async {
    if (_isRefreshing) return _refreshCompleter?.future;

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(null);
        return null;
      }

      final response = await _dio.post(
        ApiPaths.refresh,
        data: {"refreshToken": refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final newAccess = data["accessToken"] as String;
      final newRefresh = data["refreshToken"] as String;

      await _storage.saveTokens(accessToken: newAccess, refreshToken: newRefresh);
      _refreshCompleter!.complete(newAccess);
      return newAccess;
    } catch (e) {
      _refreshCompleter!.completeError(e);
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Enveloppe une DioException en y attachant un AppException typé.
  DioException _wrap(DioException err) {
    final exception = _toAppException(err);
    return DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      error: exception,
      message: exception.message,
    );
  }

  AppException _toAppException(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return AppException.timeout();
    }
    if (err.type == DioExceptionType.connectionError) {
      return AppException.network();
    }
    final status = err.response?.statusCode;
    if (status == null) return AppException.unknown();
    return switch (status) {
      401 => AppException.unauthorized(),
      404 => AppException.notFound(),
      409 => AppException.conflict(),
      429 => AppException.rateLimited(),
      503 => AppException.serviceUnavailable(),
      _ when status >= 500 => AppException.serverError(),
      _ => AppException.unknown(),
    };
  }
}
