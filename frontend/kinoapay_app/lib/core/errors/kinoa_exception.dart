import "package:kinoapay_app/core/constants/kinoa_error_codes.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";

/// Exception typée de l'application KinoaPay, propagée depuis les repositories vers les BLoCs.
/// Chaque feature peut étendre ce système en définissant ses propres codes dans son fichier [feature]_error_codes.dart.
class KinoaException implements Exception {
  final String message;
  final String code;
  final int? statusCode;

  /// @param message     Message utilisateur décrivant l'erreur
  /// @param code        Code interne issu de [KinoaErrorCodes] ou des codes de feature
  /// @param statusCode  Code HTTP associé, null si l'erreur est cliente
  const KinoaException({
    required this.message,
    required this.code,
    this.statusCode,
  });

  factory KinoaException.noInternet() => const KinoaException(
        message: KinoaStrings.errorNoInternet,
        code: KinoaErrorCodes.noInternet,
      );

  factory KinoaException.timeout() => const KinoaException(
        message: KinoaStrings.errorTimeout,
        code: KinoaErrorCodes.timeout,
      );

  factory KinoaException.network() => const KinoaException(
        message: KinoaStrings.errorNetwork,
        code: KinoaErrorCodes.network,
      );

  factory KinoaException.unauthorized() => const KinoaException(
        message: KinoaStrings.errorUnauthorized,
        code: KinoaErrorCodes.unauthorized,
        statusCode: 401,
      );

  factory KinoaException.tokenInvalid() => const KinoaException(
        message: KinoaStrings.errorTokenInvalid,
        code: KinoaErrorCodes.tokenInvalid,
        statusCode: 401,
      );

  factory KinoaException.sessionRevoked() => const KinoaException(
        message: KinoaStrings.errorSessionRevoked,
        code: KinoaErrorCodes.sessionRevoked,
        statusCode: 401,
      );

  factory KinoaException.serverError() => const KinoaException(
        message: KinoaStrings.errorServer,
        code: KinoaErrorCodes.serverError,
        statusCode: 500,
      );

  factory KinoaException.serviceUnavailable() => const KinoaException(
        message: KinoaStrings.errorServiceUnavailable,
        code: KinoaErrorCodes.serviceUnavailable,
        statusCode: 503,
      );

  factory KinoaException.notFound() => const KinoaException(
        message: KinoaStrings.errorNotFound,
        code: KinoaErrorCodes.notFound,
        statusCode: 404,
      );

  factory KinoaException.conflict() => const KinoaException(
        message: KinoaStrings.errorConflict,
        code: KinoaErrorCodes.conflict,
        statusCode: 409,
      );

  factory KinoaException.rateLimited() => const KinoaException(
        message: KinoaStrings.errorRateLimited,
        code: KinoaErrorCodes.rateLimited,
        statusCode: 429,
      );

  /// @param detail  message utilisateur optionnel en remplacement du message par défaut
  /// @return une instance avec code [KinoaErrorCodes.localStorage]
  factory KinoaException.localStorage([String? detail]) => KinoaException(
        message: detail ?? KinoaStrings.errorLocalStorage,
        code: KinoaErrorCodes.localStorage,
      );

  factory KinoaException.unknown() => const KinoaException(
        message: KinoaStrings.errorUnknown,
        code: KinoaErrorCodes.unknown,
      );

  factory KinoaException.cancelled() => const KinoaException(
        message: KinoaStrings.errorCancelled,
        code: KinoaErrorCodes.cancelled,
      );

  @override
  String toString() => "KinoaException[$code${statusCode != null ? ':$statusCode' : ''}] $message";
}
