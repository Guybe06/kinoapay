import "package:equatable/equatable.dart";
import "package:kinoapay_app/core/domain/kinoa_user_type.dart";

/// Transaction financière (données mock ou futures données API).
class Transaction extends Equatable {
  final String transactionId;
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

  /// Type du participant externe à la transaction (destinataire si sent, émetteur si received).
  final KinoaUserType counterpartType;

  const Transaction({
    required this.transactionId,
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
    this.counterpartType = KinoaUserType.individual,
  });

  @override
  List<Object?> get props => [
        transactionId,
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
        counterpartType,
      ];
}

/// Détaille la structure des frais appliqués à une transaction.
class TransactionFees extends Equatable {
  final double sourceOperatorFee;
  final double destinationOperatorFee;
  final double platformFee;
  final double totalFee;
  final double amountDebited;
  final double amountReceived;

  const TransactionFees({
    required this.sourceOperatorFee,
    required this.destinationOperatorFee,
    required this.platformFee,
    required this.totalFee,
    required this.amountDebited,
    required this.amountReceived,
  });

  @override
  List<Object?> get props => [
        sourceOperatorFee,
        destinationOperatorFee,
        platformFee,
        totalFee,
        amountDebited,
        amountReceived,
      ];
}
