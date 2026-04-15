import "package:equatable/equatable.dart";

sealed class PaymentSetupEvent extends Equatable {
  const PaymentSetupEvent();
  @override
  List<Object?> get props => [];
}

/// Initialise le setup : charge les comptes existants.
class PaymentSetupStarted extends PaymentSetupEvent {
  final String suggestedPhone;
  final String suggestedCountryCode;
  const PaymentSetupStarted({required this.suggestedPhone, required this.suggestedCountryCode});
  @override
  List<Object?> get props => [suggestedPhone, suggestedCountryCode];
}

/// L'utilisateur confirme l'ajout d'un compte pour un canal.
class PaymentAccountAdded extends PaymentSetupEvent {
  final String channelType;
  final String channelLabel;
  final String phone;
  final String countryCode;
  const PaymentAccountAdded({
    required this.channelType,
    required this.channelLabel,
    required this.phone,
    required this.countryCode,
  });
  @override
  List<Object?> get props => [channelType, phone, countryCode];
}

/// L'utilisateur supprime un compte lié.
class PaymentAccountRemoved extends PaymentSetupEvent {
  final String accountId;
  const PaymentAccountRemoved({required this.accountId});
  @override
  List<Object?> get props => [accountId];
}

/// L'utilisateur a terminé (au moins 1 compte ajouté).
class PaymentSetupCompleted extends PaymentSetupEvent {
  const PaymentSetupCompleted();
}
