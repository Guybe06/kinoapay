import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/repositories/dashboard_repository.dart";

/// Gère la logique métier et les états du tableau de bord utilisateur.
///
/// Cache en mémoire : transactions et canaux sont chargés une seule fois par session.
/// Seules les stats sont rechargées lors d'un changement de période.
/// [DashboardRefreshRequested] invalide le cache et recharge tout.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepository;

  List<Transaction>? _cachedTransactions;
  List<PaymentChannel>? _cachedChannels;

  DashboardBloc({required DashboardRepository dashboardRepository})
    : _dashboardRepository = dashboardRepository,
      super(DashboardInitial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardPeriodChanged>(_onPeriodChanged);
    on<DashboardRefreshRequested>(_onRefreshRequested);
  }

  /// Chargement initial : utilise le cache pour transactions et canaux si disponible.
  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    final hasCached = _cachedTransactions != null && _cachedChannels != null;

    if (!hasCached) emit(DashboardLoading());

    try {
      final stats = await _dashboardRepository.getStats(
        month: event.month,
        year: event.year,
      );

      if (!hasCached) {
        final results = await Future.wait([
          _dashboardRepository.getRecentTransactions(),
          _dashboardRepository.getUserChannels(),
        ]);
        _cachedTransactions = List<Transaction>.from(results[0] as Iterable);
        _cachedChannels = List<PaymentChannel>.from(results[1] as Iterable);
      }

      emit(DashboardLoadSuccess(
        stats: stats,
        transactions: _cachedTransactions!,
        channels: _cachedChannels!,
      ));
    } catch (e) {
      emit(const DashboardLoadFailure(DashboardStrings.errorLoad));
    }
  }

  /// Changement de période : recharge uniquement les stats.
  /// Transactions et canaux conservés depuis le cache — aucun DashboardLoading émis.
  Future<void> _onPeriodChanged(
    DashboardPeriodChanged event,
    Emitter<DashboardState> emit,
  ) async {
    final transactions = _cachedTransactions;
    final channels = _cachedChannels;

    if (transactions == null || channels == null) {
      add(DashboardStarted(month: event.month, year: event.year));
      return;
    }

    try {
      final stats = await _dashboardRepository.getStats(
        month: event.month,
        year: event.year,
      );

      emit(DashboardLoadSuccess(
        stats: stats,
        transactions: transactions,
        channels: channels,
      ));
    } catch (e) {
      emit(const DashboardLoadFailure(DashboardStrings.errorRefresh));
    }
  }

  /// Pull-to-refresh : invalide le cache et recharge tout.
  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    _cachedTransactions = null;
    _cachedChannels = null;

    try {
      final results = await Future.wait([
        _dashboardRepository.getStats(month: event.month, year: event.year),
        _dashboardRepository.getRecentTransactions(),
        _dashboardRepository.getUserChannels(),
      ]);

      _cachedTransactions = List<Transaction>.from(results[1] as Iterable);
      _cachedChannels = List<PaymentChannel>.from(results[2] as Iterable);

      emit(DashboardLoadSuccess(
        stats: results[0] as DashboardStats,
        transactions: _cachedTransactions!,
        channels: _cachedChannels!,
      ));
    } catch (e) {
      emit(const DashboardLoadFailure(DashboardStrings.errorRefresh));
    }
  }
}
