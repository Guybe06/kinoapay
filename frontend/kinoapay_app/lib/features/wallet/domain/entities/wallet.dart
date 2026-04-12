import "package:equatable/equatable.dart";

/// Représente le portefeuille numérique de l'utilisateur avec son solde actuel.
class Wallet extends Equatable {
  final String id;
  final String userId;
  final double balance;
  final String currency;

  const Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
  });

  @override
  List<Object?> get props => [id, userId, balance, currency];

  /// Retourne un nouveau portefeuille avec un solde ajusté pour une transaction.
  Wallet copyWith({
    double? balance,
  }) {
    return Wallet(
      id: id,
      userId: userId,
      balance: balance ?? this.balance,
      currency: currency,
    );
  }
}
