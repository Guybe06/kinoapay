/// Contrat de soumission KYC — implémenté par le mock et le HTTP repository.
abstract class KycRepository {
  Future<void> submitKyc({
    required String documentType,
    required String documentImagePath,
    required String selfieImagePath,
  });
}
