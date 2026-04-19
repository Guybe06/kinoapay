/// Utilitaires partagés de la feature contacts.
abstract final class ContactsHelpers {
  /// Génère les initiales d'un nom complet (ex : "Jean Dupont" → "JD").
  /// Utilise [String.runes] pour éviter les surrogates isolés sur les emoji.
  static String initials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length >= 2) {
      return "${_first(parts[0])}${_first(parts[1])}".toUpperCase();
    }
    return name.isNotEmpty ? _first(name).toUpperCase() : "?";
  }

  static String _first(String s) =>
      s.isNotEmpty ? String.fromCharCode(s.runes.first) : "";
}
