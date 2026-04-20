import "package:equatable/equatable.dart";
import "package:kinoapay_app/core/domain/kinoa_user_type.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";

/// Résultat d'une recherche de destinataire : identité, canaux et type de compte.
class RecipientMatch extends Equatable {
  final String name;
  final String phone;
  final List<PaymentChannel> channels;
  final KinoaUserType userType;

  const RecipientMatch({
    required this.name,
    required this.phone,
    required this.channels,
    this.userType = KinoaUserType.external,
  });

  @override
  List<Object?> get props => [name, phone, channels, userType];
}
