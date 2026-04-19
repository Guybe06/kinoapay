import "package:equatable/equatable.dart";

/// Statistiques agrégées pour un canal de paiement donné (MTN, Airtel, etc.).
class ChannelStat extends Equatable {
  final String type;
  final String label;
  final double totalSent;
  final double totalReceived;
  final int txCount;
  /// Volumes journaliers pour la sparkline (du plus ancien au plus récent).
  final List<double> sparkPoints;

  const ChannelStat({
    required this.type,
    required this.label,
    required this.totalSent,
    required this.totalReceived,
    required this.txCount,
    this.sparkPoints = const [],
  });

  double get total => totalSent + totalReceived;
  double get net => totalReceived - totalSent;

  @override
  List<Object?> get props => [
    type, label, totalSent, totalReceived, txCount, sparkPoints,
  ];
}
