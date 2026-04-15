import "package:kinoapay_app/core/constants/app_strings.dart";

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
    if (value.length < 6) return KinoaStrings.errorPasswordTooShort;
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

  /// Valide une date de naissance au format JJ/MM/AAAA, âge entre 18 et 115 ans.
  static String? validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) return KinoaStrings.errorFieldRequired;
    final parts = value.split("/");
    if (parts.length != 3) return "Format JJ/MM/AAAA attendu.";
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return "Date invalide.";
    final date = DateTime(year, month, day);
    if (date.day != day || date.month != month || date.year != year) return "Date invalide.";
    final now = DateTime.now();
    final age = now.year - date.year - ((now.month < date.month || (now.month == date.month && now.day < date.day)) ? 1 : 0);
    if (age < 18) return "Vous devez avoir au moins 18 ans.";
    if (age > 115) return "Date invalide.";
    return null;
  }

  /// Valide jour, mois et année saisis séparément (mêmes règles que [validateBirthDate]).
  static String? validateBirthDateParts(String? day, String? month, String? year) {
    final dd = (day ?? "").trim();
    final mm = (month ?? "").trim();
    final yy = (year ?? "").trim();
    if (dd.isEmpty || mm.isEmpty || yy.isEmpty) return KinoaStrings.errorFieldRequired;
    final d = int.tryParse(dd);
    final m = int.tryParse(mm);
    final y = int.tryParse(yy);
    if (d == null || m == null || y == null) return "Date invalide.";
    final combined =
        "${d.toString().padLeft(2, "0")}/${m.toString().padLeft(2, "0")}/$y";
    return validateBirthDate(combined);
  }
}
