import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/history/application/bloc/history_event.dart";
import "package:kinoapay_app/features/history/application/bloc/history_state.dart";
import "package:kinoapay_app/features/history/domain/history_filter.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";
import "package:kinoapay_app/features/history/domain/repositories/history_repository.dart";

/// Gère le chargement et le filtrage client-side de l'historique des transactions.
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _repository;
  List<Transaction>? _cache;

  HistoryBloc({required HistoryRepository repository})
      : _repository = repository,
        super(HistoryInitial()) {
    on<HistoryStarted>(_onStarted);
    on<HistoryFilterChanged>(_onFilterChanged);
  }

  Future<void> _onStarted(HistoryStarted event, Emitter<HistoryState> emit) async {
    if (_cache != null) {
      emit(HistoryLoadSuccess(all: _cache!, filter: HistoryFilter.now()));
      return;
    }
    emit(HistoryLoading());
    try {
      _cache = await _repository.getTransactions();
      emit(HistoryLoadSuccess(all: _cache!, filter: HistoryFilter.now()));
    } catch (_) {
      emit(const HistoryLoadFailure(HistoryStrings.errorLoad));
    }
  }

  void _onFilterChanged(HistoryFilterChanged event, Emitter<HistoryState> emit) {
    final cache = _cache;
    if (cache == null) return;
    emit(HistoryLoadSuccess(all: cache, filter: event.filter));
  }
}
