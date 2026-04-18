import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";

/// Résultat d'une recherche de destinataire : identité + canaux associés.
class RecipientMatch extends Equatable {
  final String name;
  final String phone;
  final List<PaymentChannel> channels;
  final bool isKinoaUser;

  const RecipientMatch({
    required this.name,
    required this.phone,
    required this.channels,
    this.isKinoaUser = false,
  });

  @override
  List<Object?> get props => [name, phone, channels, isKinoaUser];
}
