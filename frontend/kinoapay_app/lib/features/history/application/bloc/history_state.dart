import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/history/domain/history_filter.dart";

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

/// Données chargées : filtrage et pagination calculés depuis [_all].
/// Les stats portent sur toutes les transactions filtrées.
/// Seules [displayed] remonte à l'écran jusqu'à [displayCount].
class HistoryLoadSuccess extends HistoryState {
  static const int pageSize = 30;

  final List<Transaction> _all;
  final HistoryFilter filter;

  /// Nombre de transactions affichées à l'écran (pagination en mémoire).
  final int displayCount;

  const HistoryLoadSuccess({
    required List<Transaction> all,
    required this.filter,
    this.displayCount = pageSize,
  }) : _all = all;

  /// Toutes les transactions correspondant au filtre actif.
  List<Transaction> get transactions => _applyFilter(_all, filter);

  /// Tranche visible à l'écran selon [displayCount].
  List<Transaction> get displayed => transactions.take(displayCount).toList();

  /// Indique si des transactions supplémentaires peuvent être chargées.
  bool get hasMore => transactions.length > displayCount;

  double get totalSent => transactions
      .where((t) => t.direction == "sent")
      .fold(0, (s, t) => s + t.amount);

  double get totalReceived => transactions
      .where((t) => t.direction == "received")
      .fold(0, (s, t) => s + t.amount);

  double get net => totalReceived - totalSent;

  HistoryLoadSuccess copyWith({
    List<Transaction>? all,
    HistoryFilter? filter,
    int? displayCount,
  }) =>
      HistoryLoadSuccess(
        all: all ?? _all,
        filter: filter ?? this.filter,
        displayCount: displayCount ?? this.displayCount,
      );

  static List<Transaction> _applyFilter(
    List<Transaction> all,
    HistoryFilter f,
  ) {
    var txs = all;

    final now = DateTime.now();
    txs = switch (f.period) {
      HistoryPeriod.month => txs
          .where((t) => t.startedAt.month == f.month && t.startedAt.year == f.year)
          .toList(),
      HistoryPeriod.last3Months => txs
          .where((t) => t.startedAt.isAfter(now.subtract(const Duration(days: 90))))
          .toList(),
      HistoryPeriod.thisYear => txs
          .where((t) => t.startedAt.year == now.year)
          .toList(),
    };

    if (f.direction == HistoryDirection.pending) {
      txs = txs.where((t) => t.status == "PENDING" || t.status == "PROCESSING").toList();
    } else if (f.direction == HistoryDirection.sent) {
      txs = txs.where((t) => t.direction == "sent").toList();
    } else if (f.direction == HistoryDirection.received) {
      txs = txs.where((t) => t.direction == "received").toList();
    }

    if (f.channel != null) {
      txs = txs
          .where((t) => t.sourceChannel == f.channel || t.destinationChannel == f.channel)
          .toList();
    }

    return txs;
  }

  @override
  List<Object?> get props => [_all, filter, displayCount];
}

class HistoryLoadFailure extends HistoryState {
  final String message;
  const HistoryLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
