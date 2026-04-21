import "package:kinoapay_app/features/kyc/domain/entities/kyc_document_type.dart";

abstract class KycEvent {
  const KycEvent();
}

/// L'utilisateur a choisi son type de document.
class KycDocumentTypeSelected extends KycEvent {
  final KycDocumentType documentType;
  const KycDocumentTypeSelected(this.documentType);
}

/// L'utilisateur a capturé la photo du document.
class KycDocumentPhotoTaken extends KycEvent {
  final String imagePath;
  const KycDocumentPhotoTaken(this.imagePath);
}

/// L'utilisateur a capturé son selfie.
class KycSelfiePhotoTaken extends KycEvent {
  final String imagePath;
  const KycSelfiePhotoTaken(this.imagePath);
}

/// L'utilisateur confirme et soumet le dossier.
class KycSubmitRequested extends KycEvent {
  const KycSubmitRequested();
}

/// Remise à zéro du flow (retour au début).
class KycReset extends KycEvent {
  const KycReset();
}
