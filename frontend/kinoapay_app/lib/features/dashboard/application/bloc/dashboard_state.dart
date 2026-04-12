import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";

/// États du cycle de vie du tableau de bord utilisateur.
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// État initial avant le chargement des données.
class DashboardInitial extends DashboardState {}

/// Signale le chargement en cours des données du tableau de bord.
class DashboardLoading extends DashboardState {}

/// Indique que les données du tableau de bord ont été chargées avec succès.
class DashboardLoadSuccess extends DashboardState {
  final DashboardStats stats;
  final List<Transaction> transactions;
  final List<PaymentChannel> channels;

  const DashboardLoadSuccess({
    required this.stats,
    required this.transactions,
    required this.channels,
  });

  @override
  List<Object?> get props => [stats, transactions, channels];
}

/// Signale une erreur lors de la récupération des données du tableau de bord.
class DashboardLoadFailure extends DashboardState {
  final String message;

  const DashboardLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
