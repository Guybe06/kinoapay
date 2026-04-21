import "package:kinoapay_app/features/kyc/domain/kyc_strings.dart";

/// Types de documents d'identité acceptés pour la vérification KYC.
enum KycDocumentType { cni, passport, license }

extension KycDocumentTypeX on KycDocumentType {
  String get label => switch (this) {
        KycDocumentType.cni => KycStrings.docCni,
        KycDocumentType.passport => KycStrings.docPassport,
        KycDocumentType.license => KycStrings.docLicense,
      };

  String get subtitle => switch (this) {
        KycDocumentType.cni => KycStrings.docCniSub,
        KycDocumentType.passport => KycStrings.docPassportSub,
        KycDocumentType.license => KycStrings.docLicenseSub,
      };
}
