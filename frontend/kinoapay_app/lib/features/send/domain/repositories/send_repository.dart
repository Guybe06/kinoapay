import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";

/// Contrat du dépôt de transfert d'argent.
abstract class SendRepository {
  /// Demande un devis pour le transfert.
  Future<TransferQuote> getQuote({
    required String recipientIdentifier,
    required double amount,
    required String sourceChannel,
    required String destinationChannel,
  });

  /// Confirme le transfert et retourne la transaction créée.
  Future<Transaction> confirmTransfer(String quoteId);
}
