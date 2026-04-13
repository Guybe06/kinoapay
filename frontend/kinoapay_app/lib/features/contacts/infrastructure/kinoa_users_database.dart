/// Base locale des numéros enregistrés sur KinoaPay.
/// Remplacé par un appel API en Phase 1.
/// Synchronisé avec les mocks de transactions du dashboard.
const Set<String> kinoaRegisteredNumbers = {
  "+242066667788", // Jean Dupont
  "+242055554433", // Marie Claire
  "+242066660011", // Paul Mbengue
  "+242055559999", // Karim Idriss
  "+242066661122", // Fatou Diallo
  "+242055558877", // Grace Mikobi
  "+242066663344", // Théo Nganga
  "+242066665566", // Alain Bossou
};

/// Normalise un numéro de téléphone en format international (+242XXXXXXXXX).
/// Gère les formats locaux (06..., 242..., +242...).
String normalizePhone(String raw) {
  String n = raw.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');
  if (n.startsWith('00')) n = '+${n.substring(2)}';
  if (n.startsWith('0') && !n.startsWith('00')) n = '+242${n.substring(1)}';
  if (RegExp(r'^242\d+$').hasMatch(n)) n = '+$n';
  return n;
}
