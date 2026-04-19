import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";

/// Contrat d'accès aux données de l'historique des transactions.
abstract class HistoryRepository {
  Future<List<Transaction>> getTransactions();
}
