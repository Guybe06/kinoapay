import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/accounts/domain/entities/linked_account.dart";
import "package:kinoapay_app/features/accounts/domain/repositories/payment_channel_repository.dart";

/// Implémentation mock — comptes en mémoire, flag setup persisté en stockage sécurisé.
class MockPaymentChannelRepository implements PaymentChannelRepository {
  final SecureStorageService _storage;
  final List<LinkedAccount> _accounts = [];

  static const String _setupDoneKey = "channels_setup_done";

  MockPaymentChannelRepository({required SecureStorageService storage})
      : _storage = storage;

  @override
  Future<List<LinkedAccount>> getLinkedAccounts() async => List.unmodifiable(_accounts);

  @override
  Future<void> addLinkedAccount(LinkedAccount account) async {
    _accounts.removeWhere((a) => a.channelType == account.channelType);
    _accounts.add(account);
  }

  @override
  Future<void> removeLinkedAccount(String channelType) async {
    _accounts.removeWhere((a) => a.channelType == channelType);
  }

  @override
  Future<bool> isSetupDone() async => (await _storage.read(_setupDoneKey)) == "true";

  @override
  Future<void> markSetupDone() async => _storage.write(_setupDoneKey, "true");
}
