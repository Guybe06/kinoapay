import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/accounts/domain/entities/linked_account.dart";

sealed class PaymentSetupState extends Equatable {
  const PaymentSetupState();
  @override
  List<Object?> get props => [];
}

class PaymentSetupInitial extends PaymentSetupState {
  const PaymentSetupInitial();
}

class PaymentSetupLoading extends PaymentSetupState {
  const PaymentSetupLoading();
}

class PaymentSetupReady extends PaymentSetupState {
  final List<LinkedAccount> linkedAccounts;
  final String suggestedPhone;
  final String suggestedCountryCode;

  const PaymentSetupReady({
    required this.linkedAccounts,
    required this.suggestedPhone,
    required this.suggestedCountryCode,
  });

  PaymentSetupReady copyWith({List<LinkedAccount>? linkedAccounts}) {
    return PaymentSetupReady(
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      suggestedPhone: suggestedPhone,
      suggestedCountryCode: suggestedCountryCode,
    );
  }

  @override
  List<Object?> get props => [linkedAccounts, suggestedPhone, suggestedCountryCode];
}

/// Setup terminé — la vue navigue vers le shell.
class PaymentSetupDone extends PaymentSetupState {
  const PaymentSetupDone();
}
