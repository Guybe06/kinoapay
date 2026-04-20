import "package:intl/intl.dart";

/// Formateur de montants KinoaPay, source unique pour tous les écrans.
/// Utilise la locale en_US : séparateur de milliers virgule, ex. 95,000.
abstract final class AmountFormatter {
  static final _fmt = NumberFormat("#,##0", "en_US");
  static final _compact = NumberFormat.compact(locale: "en_US");

  /// Formate un montant avec séparateurs : `95,000`
  static String format(num amount) => _fmt.format(amount);

  /// Formate avec devise : `95,000 XAF`
  static String withCurrency(num amount, [String currency = "XAF"]) =>
      "${_fmt.format(amount)} $currency";

  /// Formate avec signe et devise : `+ 95,000 XAF` ou `− 95,000 XAF`
  static String signed(num amount,
      {required bool negative, String currency = "XAF"}) {
    final sign = negative ? "−" : "+";
    return "$sign ${_fmt.format(amount)} $currency";
  }

  /// Format compact pour les résumés : `95k`
  static String compact(num amount) => _compact.format(amount);

  /// Format compact avec devise : `95k XAF`
  static String compactWithCurrency(num amount, [String currency = "XAF"]) =>
      "${_compact.format(amount)} $currency";
}
