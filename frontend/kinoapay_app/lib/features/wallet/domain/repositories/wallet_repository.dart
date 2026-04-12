import "package:kinoapay_app/features/wallet/domain/entities/wallet.dart";

/// Définit le contrat d'accès aux services financiers liés au portefeuille.
abstract class WalletRepository {
  /// Récupère l'état actuel du portefeuille associé à l'utilisateur connecté.
  Future<Wallet> getWallet();

  /// Met à jour le solde du portefeuille après une transaction confirmée.
  Future<Wallet> refreshBalance();
}
