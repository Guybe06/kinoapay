import "package:equatable/equatable.dart";

/// Devis de transfert retourné avant confirmation.
class TransferQuote extends Equatable {
  final String quoteId;
  final double amount;
  final String currency;
  final double platformFee;
  final double operatorFee;
  final double totalFee;
  final double amountDebited;
  final double amountReceived;
  final String sourceChannel;
  final String destinationChannel;
  final String recipientName;
  final String recipientIdentifier;

  const TransferQuote({
    required this.quoteId,
    required this.amount,
    required this.currency,
    required this.platformFee,
    required this.operatorFee,
    required this.totalFee,
    required this.amountDebited,
    required this.amountReceived,
    required this.sourceChannel,
    required this.destinationChannel,
    required this.recipientName,
    required this.recipientIdentifier,
  });

  @override
  List<Object?> get props => [quoteId, amount, currency, totalFee, amountDebited, amountReceived];
}
