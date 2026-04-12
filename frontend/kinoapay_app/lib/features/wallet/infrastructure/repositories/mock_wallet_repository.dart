import "package:kinoapay_app/features/wallet/domain/entities/wallet.dart";
import "package:kinoapay_app/features/wallet/domain/repositories/wallet_repository.dart";

/// Implémentation factice pour le développement de l'interface du portefeuille.
class MockWalletRepository implements WalletRepository {
  /// Simule la récupération asynchrone d'un portefeuille avec un solde statique.
  @override
  Future<Wallet> getWallet() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const Wallet(
      id: "w-001",
      userId: "1",
      balance: 15450.75,
      currency: "XAF",
    );
  }

  /// Simule un rafraîchissement asynchrone en retournant les données actuelles du portefeuille.
  @override
  Future<Wallet> refreshBalance() async {
    return await getWallet();
  }
}
