import "package:kinoapay_app/features/kyc/infrastructure/kyc_repository.dart";

/// Implémentation mock : simule un délai réseau et réussit toujours.
class MockKycRepository implements KycRepository {
  @override
  Future<void> submitKyc({
    required String documentType,
    required String documentImagePath,
    required String selfieImagePath,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
  }
}
