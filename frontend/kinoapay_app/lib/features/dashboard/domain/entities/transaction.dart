import "package:equatable/equatable.dart";

/// Représente une transaction financière traitée par KinoaPay.
class Transaction extends Equatable {
  final String ktxid;
  final String status;
  final String? senderName;
  final String receiverIdentifier;
  final String? receiverName;
  final double amount;
  final String currency;
  final String sourceChannel;
  final String destinationChannel;
  final TransactionFees fees;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String direction;

  /// Score de risque AML — 0.0 = très faible, 1.0 = très élevé.
  final double? amlScore;

  const Transaction({
    required this.ktxid,
    required this.status,
    this.senderName,
    required this.receiverIdentifier,
    this.receiverName,
    required this.amount,
    required this.currency,
    required this.sourceChannel,
    required this.destinationChannel,
    required this.fees,
    required this.startedAt,
    this.completedAt,
    required this.direction,
    this.amlScore,
  });

  @override
  List<Object?> get props => [
        ktxid,
        status,
        senderName,
        receiverIdentifier,
        receiverName,
        amount,
        currency,
        sourceChannel,
        destinationChannel,
        fees,
        startedAt,
        completedAt,
        direction,
        amlScore,
      ];
}

/// Détaille la structure des frais appliqués à une transaction.
class TransactionFees extends Equatable {
  final double sourceOperatorFee;
  final double destinationOperatorFee;
  final double kinoaFee;
  final double totalFee;
  final double amountDebited;
  final double amountReceived;

  const TransactionFees({
    required this.sourceOperatorFee,
    required this.destinationOperatorFee,
    required this.kinoaFee,
    required this.totalFee,
    required this.amountDebited,
    required this.amountReceived,
  });

  @override
  List<Object?> get props => [
        sourceOperatorFee,
        destinationOperatorFee,
        kinoaFee,
        totalFee,
        amountDebited,
        amountReceived,
      ];
}
