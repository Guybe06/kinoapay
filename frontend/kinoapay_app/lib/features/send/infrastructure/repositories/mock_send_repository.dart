import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";
import "package:kinoapay_app/features/send/domain/repositories/send_repository.dart";

/// Implémentation mock du dépôt de transfert.
class MockSendRepository implements SendRepository {
  @override
  Future<TransferQuote> getQuote({
    required String recipientIdentifier,
    required double amount,
    required String sourceChannel,
    required String destinationChannel,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final platformFee = amount * 0.01;
    final operatorFee = amount * 0.005;
    final totalFee = platformFee + operatorFee;
    return TransferQuote(
      quoteId: "quote_${DateTime.now().millisecondsSinceEpoch}",
      amount: amount,
      currency: "XAF",
      platformFee: platformFee,
      operatorFee: operatorFee,
      totalFee: totalFee,
      amountDebited: amount + totalFee,
      amountReceived: amount,
      sourceChannel: sourceChannel,
      destinationChannel: destinationChannel,
      recipientName: "Jean Dupont",
      recipientIdentifier: recipientIdentifier,
    );
  }

  @override
  Future<Transaction> confirmTransfer(String quoteId) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final now = DateTime.now();
    return Transaction(
      transactionId: "TX-${now.millisecondsSinceEpoch}",
      status: "success",
      senderName: "Moi",
      receiverIdentifier: "+242060000000",
      receiverName: "Jean Dupont",
      amount: 5000,
      currency: "XAF",
      sourceChannel: "MTN Mobile Money",
      destinationChannel: "Airtel Money",
      fees: const TransactionFees(
        sourceOperatorFee: 25,
        destinationOperatorFee: 0,
        platformFee: 50,
        totalFee: 75,
        amountDebited: 5075,
        amountReceived: 5000,
      ),
      startedAt: now,
      completedAt: now,
      direction: "outgoing",
    );
  }
}
