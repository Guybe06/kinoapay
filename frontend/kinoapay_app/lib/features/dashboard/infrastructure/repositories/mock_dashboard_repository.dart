import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/domain/repositories/dashboard_repository.dart";

/// Implémentation factice pour simuler les données du tableau de bord.
class MockDashboardRepository implements DashboardRepository {
  /// Simule la récupération des statistiques financières agrégées.
  @override
  Future<DashboardStats> getStats({required int month, required int year}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const DashboardStats(
      totalSent: 125000,
      totalReceived: 450000,
      currency: "XAF",
    );
  }

  /// Retourne une liste simulée de transactions récentes pour l'utilisateur.
  @override
  Future<List<Transaction>> getRecentTransactions() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      Transaction(
        ktxid: "KTX-2026-ABC123",
        status: "COMPLETED",
        receiverIdentifier: "+242066667788",
        receiverName: "Jean Dupont",
        amount: 25000,
        currency: "XAF",
        sourceChannel: "MTN",
        destinationChannel: "Airtel",
        fees: const TransactionFees(
          sourceOperatorFee: 250,
          destinationOperatorFee: 0,
          kinoaFee: 150,
          totalFee: 400,
          amountDebited: 25400,
          amountReceived: 25000,
        ),
        startedAt: DateTime.now().subtract(const Duration(hours: 2)),
        direction: "sent",
      ),
      Transaction(
        ktxid: "KTX-2026-XYZ789",
        status: "COMPLETED",
        receiverIdentifier: "+242055554433",
        senderName: "Marie Claire",
        amount: 15000,
        currency: "XAF",
        sourceChannel: "Airtel",
        destinationChannel: "MTN",
        fees: const TransactionFees(
          sourceOperatorFee: 150,
          destinationOperatorFee: 0,
          kinoaFee: 100,
          totalFee: 250,
          amountDebited: 15250,
          amountReceived: 15000,
        ),
        startedAt: DateTime.now().subtract(const Duration(days: 1)),
        direction: "received",
      ),
    ];
  }

  /// Fournit les canaux de paiement actifs simulés pour le profil utilisateur.
  @override
  Future<List<PaymentChannel>> getUserChannels() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      PaymentChannel(
        id: "ch_001",
        type: "mobile",
        label: "MTN Mobile Money",
        value: "+242064445566",
        short: "MTN",
        status: "active",
        lastUsed: DateTime.now(),
      ),
      PaymentChannel(
        id: "ch_002",
        type: "mobile",
        label: "Airtel Money",
        value: "+242055551122",
        short: "Airtel",
        status: "active",
        lastUsed: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
