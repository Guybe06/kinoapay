import "package:equatable/equatable.dart";

/// Événements fondamentaux régissant le cycle de vie du portefeuille utilisateur.
abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

/// Déclenche le chargement initial de l'état du portefeuille.
class WalletStarted extends WalletEvent {}

/// Demande la mise à jour immédiate du solde du portefeuille.
class WalletRefreshRequested extends WalletEvent {}
