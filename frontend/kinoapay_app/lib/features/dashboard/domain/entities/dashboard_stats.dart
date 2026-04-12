import "package:equatable/equatable.dart";

/// Regroupe les statistiques financières agrégées pour une période donnée.
class DashboardStats extends Equatable {
  final double totalSent;
  final double totalReceived;
  final String currency;

  const DashboardStats({
    required this.totalSent,
    required this.totalReceived,
    required this.currency,
  });

  @override
  List<Object?> get props => [totalSent, totalReceived, currency];
}
