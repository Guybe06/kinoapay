import "package:kinoapay_app/core/constants/kinoa_strings.dart";

/// Fournit les services de validation pour les données d'authentification utilisateur.
class AuthValidator {
  /// Valide le format de l'adresse email ou du numéro mobile, retourne null si valide.
  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) return KinoaStrings.errorFieldRequired;
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final phoneRegex = RegExp(r"^\+?[0-9]{8,15}$");
    if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) return KinoaStrings.errorInvalidEmail;
    return null;
  }

  /// Valide la conformité du mot de passe, retourne null si valide (longueur ≥ 8).
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return KinoaStrings.errorFieldRequired;
    if (value.length < 8) return KinoaStrings.errorPasswordTooShort;
    return null;
  }

  /// Valide un prénom ou nom (non vide, lettres uniquement, min 2 chars).
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return KinoaStrings.errorFieldRequired;
    if (value.trim().length < 2) return "Minimum 2 caractères.";
    return null;
  }

  /// Valide un numéro de téléphone (chiffres uniquement, 6 à 12 chiffres après formatage).
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return KinoaStrings.errorFieldRequired;
    final digits = value.replaceAll(RegExp(r"\D"), "");
    if (digits.length < 6 || digits.length > 12) return "Numéro invalide.";
    return null;
  }

  /// Valide une date de naissance au format JJ/MM/AAAA, âge minimum 16 ans.
  static String? validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) return KinoaStrings.errorFieldRequired;
    final parts = value.split("/");
    if (parts.length != 3) return "Format JJ/MM/AAAA attendu.";
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return "Date invalide.";
    final date = DateTime(year, month, day);
    final now = DateTime.now();
    final age = now.year - date.year - ((now.month < date.month || (now.month == date.month && now.day < date.day)) ? 1 : 0);
    if (age < 16) return "Vous devez avoir au moins 16 ans.";
    if (age > 120) return "Date invalide.";
    return null;
  }
}
