import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/domain/repositories/dashboard_repository.dart";

/// Gère la logique métier et les états du tableau de bord utilisateur.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardBloc({required DashboardRepository dashboardRepository})
      : _dashboardRepository = dashboardRepository,
        super(DashboardInitial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardRefreshRequested>(_onRefreshRequested);
  }

  /// Orchestre le chargement initial des données du tableau de bord.
  Future<void> _onStarted(DashboardStarted event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final results = await Future.wait([
        _dashboardRepository.getStats(month: event.month, year: event.year),
        _dashboardRepository.getRecentTransactions(),
        _dashboardRepository.getUserChannels(),
      ]);

      emit(DashboardLoadSuccess(
        stats: results[0] as dynamic,
        transactions: results[1] as List<dynamic>,
        channels: results[2] as List<dynamic>,
      ));
    } catch (e) {
      emit(const DashboardLoadFailure("Impossible de charger les données du tableau de bord"));
    }
  }

  /// Actualise les données du tableau de bord sans afficher l'état de chargement initial.
  Future<void> _onRefreshRequested(DashboardRefreshRequested event, Emitter<DashboardState> emit) async {
    try {
      final results = await Future.wait([
        _dashboardRepository.getStats(month: event.month, year: event.year),
        _dashboardRepository.getRecentTransactions(),
        _dashboardRepository.getUserChannels(),
      ]);

      emit(DashboardLoadSuccess(
        stats: results[0] as dynamic,
        transactions: results[1] as List<dynamic>,
        channels: results[2] as List<dynamic>,
      ));
    } catch (e) {
      emit(const DashboardLoadFailure("Échec du rafraîchissement des données"));
    }
  }
}
