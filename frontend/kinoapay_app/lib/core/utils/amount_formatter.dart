import "package:intl/intl.dart";

/// Formateur de montants KinoaPay — source unique pour tous les écrans.
abstract final class AmountFormatter {
  static final _fmt = NumberFormat("#,###", "fr_FR");
  static final _compact = NumberFormat.compact(locale: "fr_FR");

  /// Formate un montant avec séparateurs : `12 500`
  static String format(num amount) => _fmt.format(amount);

  /// Formate avec devise : `12 500 XAF`
  static String withCurrency(num amount, [String currency = "XAF"]) =>
      "${_fmt.format(amount)} $currency";

  /// Formate avec signe et devise : `+ 12 500 XAF` ou `− 12 500 XAF`
  static String signed(num amount,
      {required bool negative, String currency = "XAF"}) {
    final sign = negative ? "−" : "+";
    return "$sign ${_fmt.format(amount)} $currency";
  }

  /// Format compact pour les résumés : `12,5k`
  static String compact(num amount) => _compact.format(amount);

  /// Format compact avec devise : `12,5k XAF`
  static String compactWithCurrency(num amount, [String currency = "XAF"]) =>
      "${_compact.format(amount)} $currency";
}
