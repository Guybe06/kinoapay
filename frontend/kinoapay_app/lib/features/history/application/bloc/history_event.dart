import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/history/domain/history_filter.dart";

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
  @override
  List<Object?> get props => [];
}

/// Initialise le chargement de l'historique complet.
class HistoryStarted extends HistoryEvent {
  const HistoryStarted();
}

/// Applique un nouveau filtre sur la liste en mémoire.
class HistoryFilterChanged extends HistoryEvent {
  final HistoryFilter filter;
  const HistoryFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Demande l'affichage de la page suivante (pagination en mémoire).
class HistoryMoreRequested extends HistoryEvent {
  const HistoryMoreRequested();
}
