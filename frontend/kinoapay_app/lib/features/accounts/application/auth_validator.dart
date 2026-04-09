import "package:kinoapay_app/core/constants/kinoa_strings.dart";

/// Fournit les services de validation pour les données d'authentification utilisateur.
class AuthValidator {
  /// Valide le format de l'adresse email ou du numéro mobile.
  /// 
  /// Retourne un message d'erreur si invalide, sinon null.
  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return KinoaStrings.errorFieldRequired;
    }

    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final phoneRegex = RegExp(r"^\+?[0-9]{8,15}$");

    if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
      return KinoaStrings.errorInvalidEmail;
    }
    
    return null;
  }

  /// Valide la conformité du mot de passe.
  /// 
  /// Retourne un message d'erreur si la longueur est insuffisante (< 8), sinon null.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return KinoaStrings.errorFieldRequired;
    }
    
    if (value.length < 8) {
      return KinoaStrings.errorPasswordTooShort;
    }

    return null;
  }
}
