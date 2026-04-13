import "package:equatable/equatable.dart";

/// Volume journalier de transactions (reçu + envoyé) pour un jour donné.
class DailyVolume extends Equatable {
  final DateTime date;
  final double received;
  final double sent;

  const DailyVolume({
    required this.date,
    required this.received,
    required this.sent,
  });

  double get net => received - sent;
  double get total => received + sent;

  @override
  List<Object?> get props => [date, received, sent];
}
