import "package:kinoapay_app/core/domain/kinoa_user_type.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/history/domain/repositories/history_repository.dart";

/// Mock de l'historique des transactions — couvre les 3 derniers mois.
class MockHistoryRepository implements HistoryRepository {
  @override
  Future<List<Transaction>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 700));
    final now = DateTime.now();

    Transaction tx(
      String id, String status, String? senderName, String? receiverName,
      String receiverId, double amount, String src, String dest, String dir,
      Duration ago, TransactionFees fees, KinoaUserType type,
    ) {
      return Transaction(
        transactionId: id, status: status,
        senderName: senderName, receiverName: receiverName,
        receiverIdentifier: receiverId,
        amount: amount, currency: "XAF",
        sourceChannel: src, destinationChannel: dest,
        fees: fees, startedAt: now.subtract(ago), direction: dir,
        counterpartType: type,
      );
    }

    const f1 = TransactionFees(sourceOperatorFee: 250, destinationOperatorFee: 0, platformFee: 150, totalFee: 400, amountDebited: 25400, amountReceived: 25000);
    const f2 = TransactionFees(sourceOperatorFee: 150, destinationOperatorFee: 0, platformFee: 100, totalFee: 250, amountDebited: 15250, amountReceived: 15000);
    const f3 = TransactionFees(sourceOperatorFee: 500, destinationOperatorFee: 0, platformFee: 300, totalFee: 800, amountDebited: 50800, amountReceived: 50000);
    const f4 = TransactionFees(sourceOperatorFee: 350, destinationOperatorFee: 0, platformFee: 200, totalFee: 550, amountDebited: 35550, amountReceived: 35000);
    const f5 = TransactionFees(sourceOperatorFee: 800, destinationOperatorFee: 0, platformFee: 500, totalFee: 1300, amountDebited: 81300, amountReceived: 80000);
    const f6 = TransactionFees(sourceOperatorFee: 1200, destinationOperatorFee: 0, platformFee: 700, totalFee: 1900, amountDebited: 121900, amountReceived: 120000);
    const f7 = TransactionFees(sourceOperatorFee: 400, destinationOperatorFee: 0, platformFee: 250, totalFee: 650, amountDebited: 40650, amountReceived: 40000);

    const i = KinoaUserType.individual;
    const m = KinoaUserType.merchant;
    const e = KinoaUserType.external;

    return [
      tx("TX-001", "COMPLETED", null, "Jean Dupont", "+242066667788", 25000, "MTN", "AIRTEL", "sent", const Duration(hours: 1), f1, i),
      tx("TX-002", "COMPLETED", "Boutique Mama Africa", null, "+242055554433", 15000, "AIRTEL", "MTN", "received", const Duration(hours: 3), f2, m),
      tx("TX-003", "COMPLETED", null, "Paul Mbengue", "+242066660011", 50000, "MTN", "MTN", "sent", const Duration(days: 1, hours: 10), f3, e),
      tx("TX-004", "COMPLETED", "Karim Idriss", null, "+242055559999", 35000, "AIRTEL", "AIRTEL", "received", const Duration(days: 1, hours: 14), f4, i),
      tx("TX-005", "COMPLETED", "Pharmacie Centrale", null, "+242066661122", 35000, "MTN", "AIRTEL", "received", const Duration(days: 2, hours: 9), f4, m),
      tx("TX-006", "COMPLETED", "Grace Mikobi", null, "+242055558877", 80000, "MTN", "MTN", "received", const Duration(days: 3, hours: 8), f5, i),
      tx("TX-007", "PENDING", null, "Théo Nganga", "+242066663344", 40000, "AIRTEL", "MTN", "sent", const Duration(days: 3, hours: 16), f7, e),
      tx("TX-008", "COMPLETED", "Restaurant Le Fleuve", null, "+242066665566", 120000, "MTN", "AIRTEL", "received", const Duration(days: 5, hours: 11), f6, m),
      tx("TX-009", "COMPLETED", null, "Rosine Kaya", "+242055552233", 18000, "AIRTEL", "AIRTEL", "sent", const Duration(days: 8), f2, i),
      tx("TX-010", "COMPLETED", "Bertrand Loko", null, "+242066664455", 65000, "MTN", "MTN", "received", const Duration(days: 10), f3, i),
      tx("TX-011", "FAILED", null, "Inconnu", "+242055556677", 30000, "AIRTEL", "MTN", "sent", const Duration(days: 12), f4, e),
      tx("TX-012", "COMPLETED", "Sophie Mbaki", null, "+242066668899", 90000, "MTN", "AIRTEL", "received", const Duration(days: 15), f5, i),
      tx("TX-013", "COMPLETED", null, "Supermarché Score", "+242055550011", 22000, "MTN", "MTN", "sent", const Duration(days: 18), f1, m),
      tx("TX-014", "COMPLETED", "Ines Ngolo", null, "+242066662233", 45000, "AIRTEL", "AIRTEL", "received", const Duration(days: 22), f4, i),
      tx("TX-015", "COMPLETED", null, "Martial Banda", "+242055553344", 75000, "MTN", "AIRTEL", "sent", const Duration(days: 25), f3, e),
      tx("TX-016", "COMPLETED", "Clara Moussoki", null, "+242066667711", 110000, "AIRTEL", "MTN", "received", const Duration(days: 35), f6, i),
      tx("TX-017", "COMPLETED", null, "Eric Ngouma", "+242055558800", 28000, "MTN", "MTN", "sent", const Duration(days: 42), f2, i),
      tx("TX-018", "COMPLETED", "Telecel Congo", null, "+242066669922", 55000, "AIRTEL", "AIRTEL", "received", const Duration(days: 50), f3, m),
      tx("TX-019", "PROCESSING", null, "Serge Dzabakissa", "+242055551199", 33000, "MTN", "AIRTEL", "sent", const Duration(days: 58), f4, e),
      tx("TX-020", "COMPLETED", "Aurelie Taty", null, "+242066661100", 88000, "MTN", "MTN", "received", const Duration(days: 65), f5, i),
    ];
  }
}
