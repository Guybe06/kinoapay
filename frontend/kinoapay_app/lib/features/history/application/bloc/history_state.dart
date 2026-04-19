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

/// Données chargées — le filtrage est calculé à la demande depuis [_all].
class HistoryLoadSuccess extends HistoryState {
  final List<Transaction> _all;
  final HistoryFilter filter;

  const HistoryLoadSuccess({
    required List<Transaction> all,
    required this.filter,
  }) : _all = all;

  List<Transaction> get transactions => _applyFilter(_all, filter);

  double get totalSent => transactions
      .where((t) => t.direction == "sent")
      .fold(0, (s, t) => s + t.amount);

  double get totalReceived => transactions
      .where((t) => t.direction == "received")
      .fold(0, (s, t) => s + t.amount);

  double get net => totalReceived - totalSent;

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
  List<Object?> get props => [_all, filter];
}

class HistoryLoadFailure extends HistoryState {
  final String message;
  const HistoryLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
