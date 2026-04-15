import "package:kinoapay_app/core/constants/app_strings.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Validation des données d'authentification utilisateur.
abstract final class AuthValidator {
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  static final RegExp _phoneRegex = RegExp(r"^\+?[0-9]{8,15}$");
  static final RegExp _nonDigitRegex = RegExp(r"\D");

  /// Valide le format de l'adresse email ou du numéro mobile.
  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) return AppStrings.errorFieldRequired;
    if (!_emailRegex.hasMatch(value) && !_phoneRegex.hasMatch(value))
      return AppStrings.errorInvalidEmail;
    return null;
  }

  /// Valide la conformité du mot de passe (longueur ≥ 6).
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.errorFieldRequired;
    if (value.length < 6) return AppStrings.errorPasswordTooShort;
    return null;
  }

  /// Valide un prénom ou nom (min 2 caractères).
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty)
      return AppStrings.errorFieldRequired;
    if (value.trim().length < 2) return AuthStrings.validatorMinChars;
    return null;
  }

  /// Valide un numéro de téléphone (6 à 12 chiffres).
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty)
      return AppStrings.errorFieldRequired;
    final digits = value.replaceAll(_nonDigitRegex, "");
    if (digits.length < 6 || digits.length > 12)
      return AuthStrings.validatorInvalidPhone;
    return null;
  }

  /// Valide une date de naissance au format JJ/MM/AAAA, âge entre 18 et 115 ans.
  static String? validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty)
      return AppStrings.errorFieldRequired;
    final parts = value.split("/");
    if (parts.length != 3) return AuthStrings.validatorDateFormat;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null)
      return AuthStrings.validatorInvalidDate;
    final date = DateTime(year, month, day);
    if (date.day != day || date.month != month || date.year != year)
      return AuthStrings.validatorInvalidDate;
    final now = DateTime.now();
    final age =
        now.year -
        date.year -
        ((now.month < date.month ||
                (now.month == date.month && now.day < date.day))
            ? 1
            : 0);
    if (age < 18) return AuthStrings.validatorMinAge;
    if (age > 115) return AuthStrings.validatorInvalidDate;
    return null;
  }

  /// Valide jour, mois et année saisis séparément.
  static String? validateBirthDateParts(
    String? day,
    String? month,
    String? year,
  ) {
    final dd = (day ?? "").trim();
    final mm = (month ?? "").trim();
    final yy = (year ?? "").trim();
    if (dd.isEmpty || mm.isEmpty || yy.isEmpty)
      return AppStrings.errorFieldRequired;
    final d = int.tryParse(dd);
    final m = int.tryParse(mm);
    final y = int.tryParse(yy);
    if (d == null || m == null || y == null)
      return AuthStrings.validatorInvalidDate;
    final combined =
        "${d.toString().padLeft(2, "0")}/${m.toString().padLeft(2, "0")}/$y";
    return validateBirthDate(combined);
  }
}
