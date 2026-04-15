import "package:kinoapay_app/features/accounts/domain/entities/linked_account.dart";

/// Contrat de persistance des comptes de paiement liés.
abstract class PaymentChannelRepository {
  Future<List<LinkedAccount>> getLinkedAccounts();
  Future<void> addLinkedAccount(LinkedAccount account);
  Future<void> removeLinkedAccount(String id);

  /// true si l'utilisateur a au moins configuré ou ignoré l'étape de setup.
  Future<bool> isSetupDone();
  Future<void> markSetupDone();
}
