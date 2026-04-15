import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";

/// Profil mock : identifiant public affichable et canaux de paiement.
typedef SeedUserProfile = ({String publicHandle, List<PaymentChannel> channels});

/// Profils indexés par numéro normalisé ; alignés sur les mocks du dashboard, remplacés par l’API en phase 1.
final Map<String, SeedUserProfile> usersByNormalizedPhone = {
  "+242066667788": (publicHandle: "jean.dupont", channels: [PaymentChannel.mtn]),
  "+242055554433": (publicHandle: "marie.claire", channels: [PaymentChannel.airtel]),
  "+242066660011": (publicHandle: "paul.mbengue", channels: [PaymentChannel.mtn, PaymentChannel.airtel]),
  "+242055559999": (publicHandle: "karim.idriss", channels: [PaymentChannel.mtn]),
  "+242066661122": (publicHandle: "fatou.diallo", channels: [PaymentChannel.airtel]),
  "+242055558877": (publicHandle: "grace.mikobi", channels: [PaymentChannel.airtel]),
  "+242066663344": (publicHandle: "theo.nganga", channels: [PaymentChannel.mtn]),
  "+242066665566": (publicHandle: "alain.bossou", channels: [PaymentChannel.mtn, PaymentChannel.airtel]),
};

/// Normalise un numéro au format international (+242…), à partir des formats locaux 06…, 242… ou +242….
String normalizePhone(String raw) {
  String n = raw.replaceAll(RegExp(r"[\s\-\.\(\)]"), "");
  if (n.startsWith("00")) n = "+${n.substring(2)}";
  if (n.startsWith("0") && !n.startsWith("00")) n = "+242${n.substring(1)}";
  if (RegExp(r"^242\d+$").hasMatch(n)) n = "+$n";
  return n;
}
