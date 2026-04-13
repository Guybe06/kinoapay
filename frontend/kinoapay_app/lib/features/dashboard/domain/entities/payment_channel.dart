import "package:equatable/equatable.dart";

/// Représente un canal de paiement lié au compte de l'utilisateur.
class PaymentChannel extends Equatable {
  final String id;
  final String type;
  final String label;
  final String value;
  final String short;
  final String status;
  final DateTime? lastUsed;
  /// Nombre de transactions effectuées via ce canal.
  final int txCount;

  const PaymentChannel({
    required this.id,
    required this.type,
    required this.label,
    required this.value,
    required this.short,
    required this.status,
    this.lastUsed,
    this.txCount = 0,
  });

  @override
  List<Object?> get props => [id, type, label, value, short, status, lastUsed, txCount];
}
