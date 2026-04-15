import "package:equatable/equatable.dart";

/// Canal de paiement mobile lié au compte utilisateur.
enum PaymentChannel { mtn, airtel }

/// Entrée répertoire enrichie du statut d'inscription sur la plateforme.
class Contact extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final bool isRegistered;

  /// Identifiant public ; présent uniquement si [isRegistered] est true.
  final String? publicHandle;

  /// Canaux de paiement configurés sur le compte du contact.
  final List<PaymentChannel> channels;

  const Contact({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.isRegistered,
    this.publicHandle,
    this.channels = const [],
  });

  @override
  List<Object?> get props => [id, phone];
}
