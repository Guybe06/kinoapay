import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/wallet/domain/entities/wallet.dart";

/// États du cycle de vie de la gestion du portefeuille utilisateur.
abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

/// État par défaut avant toute interaction avec le portefeuille.
class WalletInitial extends WalletState {}

/// Signale le traitement en cours d'une requête de données financières.
class WalletLoading extends WalletState {}

/// Indique que le portefeuille a été chargé avec succès et fournit ses données.
class WalletLoadSuccess extends WalletState {
  final Wallet wallet;

  const WalletLoadSuccess(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

/// Signale une erreur lors de l'accès aux données financières de l'utilisateur.
class WalletLoadFailure extends WalletState {
  final String message;

  const WalletLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
