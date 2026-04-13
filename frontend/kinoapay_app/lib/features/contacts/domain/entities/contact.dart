import "package:equatable/equatable.dart";

/// Canal de paiement mobile configuré sur un compte KinoaPay.
enum PaymentChannel { mtn, airtel }

/// Contact issu du répertoire téléphonique, enrichi avec son statut KinoaPay.
class Contact extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final bool isOnKinoaPay;

  /// Identifiant KinoaPay, disponible uniquement si [isOnKinoaPay] est true.
  final String? kinoaId;

  /// Canaux de paiement configurés sur le compte du contact.
  final List<PaymentChannel> channels;

  const Contact({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.isOnKinoaPay,
    this.kinoaId,
    this.channels = const [],
  });

  @override
  List<Object?> get props => [id, phone];
}
