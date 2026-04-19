import "package:equatable/equatable.dart";

/// Canal de paiement mobile lié au compte utilisateur.
enum PaymentChannel { mtn, airtel }

/// Entrée répertoire enrichie du statut d'inscription sur la plateforme.
class Contact extends Equatable {
  final String id;
  final String fullName;

  /// Numéro complet au format international (ex. +242066667788). Utilisé pour les appels API.
  final String phone;

  /// Indicatif du pays détecté (ex. "+242"). Vide si pays non supporté.
  final String dialCode;

  /// Numéro local sans indicatif (ex. "066667788"). Utilisé pour l'affichage et les champs saisie.
  final String localNumber;

  final bool isRegistered;

  /// Identifiant public ; présent uniquement si [isRegistered] est true.
  final String? publicHandle;

  /// Canaux de paiement configurés sur le compte du contact.
  final List<PaymentChannel> channels;

  const Contact({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.dialCode,
    required this.localNumber,
    required this.isRegistered,
    this.publicHandle,
    this.channels = const [],
  });

  @override
  List<Object?> get props => [id, phone];
}
