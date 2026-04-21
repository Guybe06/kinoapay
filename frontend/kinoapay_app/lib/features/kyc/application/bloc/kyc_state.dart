import "package:kinoapay_app/features/kyc/domain/entities/kyc_document_type.dart";

abstract class KycState {
  const KycState();
}

/// État initial : aucun document sélectionné.
class KycInitial extends KycState {
  const KycInitial();
}

/// Document choisi, en attente de la photo recto.
class KycDocumentSelected extends KycState {
  final KycDocumentType documentType;
  const KycDocumentSelected(this.documentType);
}

/// Photo du document capturée, en attente du selfie.
class KycDocumentPhotoCaptured extends KycState {
  final KycDocumentType documentType;
  final String documentImagePath;
  const KycDocumentPhotoCaptured({
    required this.documentType,
    required this.documentImagePath,
  });
}

/// Selfie capturé — prêt à soumettre.
class KycReadyToSubmit extends KycState {
  final KycDocumentType documentType;
  final String documentImagePath;
  final String selfieImagePath;
  const KycReadyToSubmit({
    required this.documentType,
    required this.documentImagePath,
    required this.selfieImagePath,
  });
}

/// Soumission en cours (appel API).
class KycSubmitting extends KycState {
  const KycSubmitting();
}

/// Dossier soumis avec succès — en attente de validation backend.
class KycSubmitted extends KycState {
  const KycSubmitted();
}

/// Erreur lors de la soumission.
class KycError extends KycState {
  final String message;
  const KycError(this.message);
}
