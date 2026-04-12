import "package:equatable/equatable.dart";

/// Événements déclenchant des changements d'état dans le tableau de bord.
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Initialise le chargement de toutes les données nécessaires au tableau de bord.
class DashboardStarted extends DashboardEvent {
  final int month;
  final int year;

  const DashboardStarted({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}

/// Demande le rafraîchissement des données pour la période actuelle.
class DashboardRefreshRequested extends DashboardEvent {
  final int month;
  final int year;

  const DashboardRefreshRequested({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}
