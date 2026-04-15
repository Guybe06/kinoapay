import "package:kinoapay_app/features/dashboard/domain/entities/channel_stat.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/daily_volume.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/domain/repositories/dashboard_repository.dart";

class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardStats> getStats({required int month, required int year}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now();

    // Volumes journaliers — J-7 à J-1 (sans aujourd'hui)
    final dailyVolumes = [
      DailyVolume(
        date: now.subtract(const Duration(days: 7)),
        received: 0,
        sent: 25000,
      ),
      DailyVolume(
        date: now.subtract(const Duration(days: 6)),
        received: 45000,
        sent: 0,
      ),
      DailyVolume(
        date: now.subtract(const Duration(days: 5)),
        received: 120000,
        sent: 20000,
      ),
      DailyVolume(
        date: now.subtract(const Duration(days: 4)),
        received: 0,
        sent: 15000,
      ),
      DailyVolume(
        date: now.subtract(const Duration(days: 3)),
        received: 80000,
        sent: 40000,
      ),
      DailyVolume(
        date: now.subtract(const Duration(days: 2)),
        received: 35000,
        sent: 0,
      ),
      DailyVolume(
        date: now.subtract(const Duration(days: 1)),
        received: 50000,
        sent: 25000,
      ),
    ];

    const channelStats = [
      ChannelStat(
        type: "MTN",
        label: "MTN Mobile Money",
        totalSent: 75000,
        totalReceived: 330000,
        txCount: 8,
      ),
      ChannelStat(
        type: "AIRTEL",
        label: "Airtel Money",
        totalSent: 50000,
        totalReceived: 120000,
        txCount: 5,
      ),
    ];

    return DashboardStats(
      totalSent: 125000,
      totalReceived: 450000,
      currency: "XAF",
      dailyVolumes: dailyVolumes,
      channelStats: channelStats,
    );
  }

  @override
  Future<List<Transaction>> getRecentTransactions() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final now = DateTime.now();

    return [
      // Aujourd'hui
      Transaction(
        transactionId: "TX-2026-T001",
        status: "COMPLETED",
        receiverIdentifier: "+242066667788",
        receiverName: "Jean Dupont",
        amount: 25000,
        currency: "XAF",
        sourceChannel: "MTN",
        destinationChannel: "Airtel",
        fees: const TransactionFees(
          sourceOperatorFee: 250, destinationOperatorFee: 0,
          platformFee: 150, totalFee: 400,
          amountDebited: 25400, amountReceived: 25000,
        ),
        startedAt: now.subtract(const Duration(hours: 1)),
        direction: "sent",
        amlScore: 0.15,
      ),
      Transaction(
        transactionId: "TX-2026-T002",
        status: "COMPLETED",
        receiverIdentifier: "+242055554433",
        senderName: "Marie Claire",
        amount: 15000,
        currency: "XAF",
        sourceChannel: "Airtel",
        destinationChannel: "MTN",
        fees: const TransactionFees(
          sourceOperatorFee: 150, destinationOperatorFee: 0,
          platformFee: 100, totalFee: 250,
          amountDebited: 15250, amountReceived: 15000,
        ),
        startedAt: now.subtract(const Duration(hours: 3)),
        direction: "received",
        amlScore: 0.22,
      ),
      // Hier
      Transaction(
        transactionId: "TX-2026-H001",
        status: "COMPLETED",
        receiverIdentifier: "+242066660011",
        receiverName: "Paul Mbengue",
        amount: 50000,
        currency: "XAF",
        sourceChannel: "MTN",
        destinationChannel: "MTN",
        fees: const TransactionFees(
          sourceOperatorFee: 500, destinationOperatorFee: 0,
          platformFee: 300, totalFee: 800,
          amountDebited: 50800, amountReceived: 50000,
        ),
        startedAt: now.subtract(const Duration(days: 1, hours: 10)),
        direction: "sent",
        amlScore: 0.48,
      ),
      Transaction(
        transactionId: "TX-2026-H002",
        status: "COMPLETED",
        receiverIdentifier: "+242055559999",
        senderName: "Karim Idriss",
        amount: 35000,
        currency: "XAF",
        sourceChannel: "Airtel",
        destinationChannel: "Airtel",
        fees: const TransactionFees(
          sourceOperatorFee: 350, destinationOperatorFee: 0,
          platformFee: 200, totalFee: 550,
          amountDebited: 35550, amountReceived: 35000,
        ),
        startedAt: now.subtract(const Duration(days: 1, hours: 14)),
        direction: "received",
        amlScore: 0.28,
      ),
      // J-2
      Transaction(
        transactionId: "TX-2026-D002",
        status: "COMPLETED",
        receiverIdentifier: "+242066661122",
        senderName: "Fatou Diallo",
        amount: 35000,
        currency: "XAF",
        sourceChannel: "MTN",
        destinationChannel: "Airtel",
        fees: const TransactionFees(
          sourceOperatorFee: 350, destinationOperatorFee: 0,
          platformFee: 200, totalFee: 550,
          amountDebited: 35550, amountReceived: 35000,
        ),
        startedAt: now.subtract(const Duration(days: 2, hours: 9)),
        direction: "received",
        amlScore: 0.74,
      ),
      // J-3
      Transaction(
        transactionId: "TX-2026-D003A",
        status: "COMPLETED",
        receiverIdentifier: "+242055558877",
        senderName: "Grace Mikobi",
        amount: 80000,
        currency: "XAF",
        sourceChannel: "MTN",
        destinationChannel: "MTN",
        fees: const TransactionFees(
          sourceOperatorFee: 800, destinationOperatorFee: 0,
          platformFee: 500, totalFee: 1300,
          amountDebited: 81300, amountReceived: 80000,
        ),
        startedAt: now.subtract(const Duration(days: 3, hours: 8)),
        direction: "received",
        amlScore: 0.38,
      ),
      Transaction(
        transactionId: "TX-2026-D003B",
        status: "PENDING",
        receiverIdentifier: "+242066663344",
        receiverName: "Théo Nganga",
        amount: 40000,
        currency: "XAF",
        sourceChannel: "Airtel",
        destinationChannel: "MTN",
        fees: const TransactionFees(
          sourceOperatorFee: 400, destinationOperatorFee: 0,
          platformFee: 250, totalFee: 650,
          amountDebited: 40650, amountReceived: 40000,
        ),
        startedAt: now.subtract(const Duration(days: 3, hours: 16)),
        direction: "sent",
        amlScore: 0.55,
      ),
      // J-5
      Transaction(
        transactionId: "TX-2026-D005",
        status: "COMPLETED",
        receiverIdentifier: "+242066665566",
        senderName: "Alain Bossou",
        amount: 120000,
        currency: "XAF",
        sourceChannel: "MTN",
        destinationChannel: "Airtel",
        fees: const TransactionFees(
          sourceOperatorFee: 1200, destinationOperatorFee: 0,
          platformFee: 700, totalFee: 1900,
          amountDebited: 121900, amountReceived: 120000,
        ),
        startedAt: now.subtract(const Duration(days: 5, hours: 11)),
        direction: "received",
        amlScore: 0.86,
      ),
    ];
  }

  @override
  Future<List<PaymentChannel>> getUserChannels() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      PaymentChannel(
        id: "ch_001",
        type: "MTN",
        label: "MTN Money",
        value: "+242064445566",
        short: "MTN",
        status: "active",
        lastUsed: DateTime.now(),
        txCount: 8,
      ),
      PaymentChannel(
        id: "ch_002",
        type: "AIRTEL",
        label: "Airtel Money",
        value: "+242055551122",
        short: "Airtel",
        status: "active",
        lastUsed: DateTime.now().subtract(const Duration(days: 2)),
        txCount: 5,
      ),
    ];
  }
}
