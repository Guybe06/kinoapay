import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/channel_stat.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/daily_volume.dart";

/// Statistiques financières agrégées pour le tableau de bord.
class DashboardStats extends Equatable {
  final double totalSent;
  final double totalReceived;
  final String currency;
  /// Volumes journaliers des 7 derniers jours (sans aujourd'hui), du plus ancien au plus récent.
  final List<DailyVolume> dailyVolumes;
  /// Répartition par canal de paiement.
  final List<ChannelStat> channelStats;

  const DashboardStats({
    required this.totalSent,
    required this.totalReceived,
    required this.currency,
    this.dailyVolumes = const [],
    this.channelStats = const [],
  });

  double get netFlow => totalReceived - totalSent;

  @override
  List<Object?> get props => [
    totalSent,
    totalReceived,
    currency,
    dailyVolumes,
    channelStats,
  ];
}
