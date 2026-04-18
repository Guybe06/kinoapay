import "package:flutter/services.dart";

/// Formatte les chiffres du champ de recherche en pattern 2+3+2+2+... : "06 445 56 61 1".
/// N'applique aucun formatage si l'entrée commence par "@" (recherche par ID Kinoa).
class PhoneSearchFormatter extends TextInputFormatter {
  static const String _idPrefix = "@";

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue next,
  ) {
    if (next.text.startsWith(_idPrefix)) return next;

    final digits = next.text.replaceAll(RegExp(r"\D"), "");
    final formatted = _formatDigits(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Insère un espace aux positions 2, 5, 7 puis tous les 2 caractères.
  String _formatDigits(String digits) {
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (_needsSpaceBefore(i)) buffer.write(" ");
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  bool _needsSpaceBefore(int index) {
    if (index == 2 || index == 5 || index == 7) return true;
    return index > 7 && (index - 7) % 2 == 0;
  }
}
