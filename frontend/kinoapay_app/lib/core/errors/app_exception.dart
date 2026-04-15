import "package:kinoapay_app/core/constants/error_codes.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";

/// Exception typée, propagée des repositories aux BLoCs ; chaque feature peut ajouter ses codes dans [feature]_error_codes.dart.
class AppException implements Exception {
  final String message;
  final String code;
  final int? statusCode;

  /// @param message     Message utilisateur décrivant l'erreur
  /// @param code        Code interne issu de [ErrorCodes] ou des codes de feature
  /// @param statusCode  Code HTTP associé, null si l'erreur est cliente
  const AppException({
    required this.message,
    required this.code,
    this.statusCode,
  });

  factory AppException.noInternet() => const AppException(
        message: AppStrings.errorNoInternet,
        code: ErrorCodes.noInternet,
      );

  factory AppException.timeout() => const AppException(
        message: AppStrings.errorTimeout,
        code: ErrorCodes.timeout,
      );

  factory AppException.network() => const AppException(
        message: AppStrings.errorNetwork,
        code: ErrorCodes.network,
      );

  factory AppException.unauthorized() => const AppException(
        message: AppStrings.errorUnauthorized,
        code: ErrorCodes.unauthorized,
        statusCode: 401,
      );

  factory AppException.tokenInvalid() => const AppException(
        message: AppStrings.errorTokenInvalid,
        code: ErrorCodes.tokenInvalid,
        statusCode: 401,
      );

  factory AppException.sessionRevoked() => const AppException(
        message: AppStrings.errorSessionRevoked,
        code: ErrorCodes.sessionRevoked,
        statusCode: 401,
      );

  factory AppException.serverError() => const AppException(
        message: AppStrings.errorServer,
        code: ErrorCodes.serverError,
        statusCode: 500,
      );

  factory AppException.serviceUnavailable() => const AppException(
        message: AppStrings.errorServiceUnavailable,
        code: ErrorCodes.serviceUnavailable,
        statusCode: 503,
      );

  factory AppException.notFound() => const AppException(
        message: AppStrings.errorNotFound,
        code: ErrorCodes.notFound,
        statusCode: 404,
      );

  factory AppException.conflict() => const AppException(
        message: AppStrings.errorConflict,
        code: ErrorCodes.conflict,
        statusCode: 409,
      );

  factory AppException.rateLimited() => const AppException(
        message: AppStrings.errorRateLimited,
        code: ErrorCodes.rateLimited,
        statusCode: 429,
      );

  /// @param detail  message utilisateur optionnel en remplacement du message par défaut
  /// @return une instance avec code [ErrorCodes.localStorage]
  factory AppException.localStorage([String? detail]) => AppException(
        message: detail ?? AppStrings.errorLocalStorage,
        code: ErrorCodes.localStorage,
      );

  factory AppException.unknown() => const AppException(
        message: AppStrings.errorUnknown,
        code: ErrorCodes.unknown,
      );

  factory AppException.cancelled() => const AppException(
        message: AppStrings.errorCancelled,
        code: ErrorCodes.cancelled,
      );

  @override
  String toString() => "AppException[$code${statusCode != null ? ':$statusCode' : ''}] $message";
}
