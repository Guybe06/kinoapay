import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";

/// Profil utilisateur côté mock : identifiant public et canaux configurés.
typedef KinoaProfile = ({String kinoaId, List<PaymentChannel> channels});

/// Base mock des profils indexés par numéro normalisé.
/// Synchronisée avec les mocks de transactions du dashboard.
/// Remplacée par un appel API en Phase 1.
final Map<String, KinoaProfile> kinoaUsersDatabase = {
  "+242066667788": (kinoaId: "jean.dupont",    channels: [PaymentChannel.mtn]),
  "+242055554433": (kinoaId: "marie.claire",   channels: [PaymentChannel.airtel]),
  "+242066660011": (kinoaId: "paul.mbengue",   channels: [PaymentChannel.mtn, PaymentChannel.airtel]),
  "+242055559999": (kinoaId: "karim.idriss",   channels: [PaymentChannel.mtn]),
  "+242066661122": (kinoaId: "fatou.diallo",   channels: [PaymentChannel.airtel]),
  "+242055558877": (kinoaId: "grace.mikobi",   channels: [PaymentChannel.airtel]),
  "+242066663344": (kinoaId: "theo.nganga",    channels: [PaymentChannel.mtn]),
  "+242066665566": (kinoaId: "alain.bossou",   channels: [PaymentChannel.mtn, PaymentChannel.airtel]),
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
