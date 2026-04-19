import "package:equatable/equatable.dart";

enum HistoryPeriod { month, last3Months, thisYear }

enum HistoryDirection { all, sent, received, pending }

/// Critères de filtrage appliqués à la liste des transactions.
class HistoryFilter extends Equatable {
  final HistoryPeriod period;
  /// Mois affiché quand [period] == [HistoryPeriod.month].
  final int month;
  final int year;
  final HistoryDirection direction;
  final String? channel;

  const HistoryFilter({
    this.period = HistoryPeriod.month,
    required this.month,
    required this.year,
    this.direction = HistoryDirection.all,
    this.channel,
  });

  factory HistoryFilter.now() {
    final n = DateTime.now();
    return HistoryFilter(month: n.month, year: n.year);
  }

  HistoryFilter prevMonth() {
    final m = month == 1 ? 12 : month - 1;
    final y = month == 1 ? year - 1 : year;
    return copyWith(period: HistoryPeriod.month, month: m, year: y);
  }

  HistoryFilter nextMonth() {
    final now = DateTime.now();
    if (year == now.year && month == now.month) return this;
    final m = month == 12 ? 1 : month + 1;
    final y = month == 12 ? year + 1 : year;
    return copyWith(period: HistoryPeriod.month, month: m, year: y);
  }

  bool get isCurrentMonth {
    final n = DateTime.now();
    return period == HistoryPeriod.month && month == n.month && year == n.year;
  }

  HistoryFilter copyWith({
    HistoryPeriod? period,
    int? month,
    int? year,
    HistoryDirection? direction,
    String? channel,
    bool clearChannel = false,
  }) => HistoryFilter(
    period: period ?? this.period,
    month: month ?? this.month,
    year: year ?? this.year,
    direction: direction ?? this.direction,
    channel: clearChannel ? null : (channel ?? this.channel),
  );

  @override
  List<Object?> get props => [period, month, year, direction, channel];
}
