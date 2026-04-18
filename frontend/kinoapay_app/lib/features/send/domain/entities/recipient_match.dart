import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";

/// Résultat d'une recherche de destinataire : identité + canaux associés.
class RecipientMatch extends Equatable {
  final String name;
  final List<PaymentChannel> channels;

  const RecipientMatch({required this.name, required this.channels});

  @override
  List<Object?> get props => [name, channels];
}
