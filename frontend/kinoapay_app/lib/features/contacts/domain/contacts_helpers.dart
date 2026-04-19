/// Utilitaires partagés de la feature contacts.
abstract final class ContactsHelpers {
  /// Génère les initiales d'un nom complet (ex : "Jean Dupont" → "JD").
  static String initials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length >= 2) return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : "?";
  }
}
