import "package:equatable/equatable.dart";

/// Compte de paiement lié à l'utilisateur sur un canal (MTN, Airtel…).
class LinkedAccount extends Equatable {
  final String id;
  final String channelType;
  final String label;
  final String phone;
  final String countryCode;

  const LinkedAccount({
    required this.id,
    required this.channelType,
    required this.label,
    required this.phone,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [id, channelType, phone, countryCode];
}
