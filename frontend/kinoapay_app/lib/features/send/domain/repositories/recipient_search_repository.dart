import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";

/// Contrat de recherche de destinataires (par ID Kinoa ou numéro de téléphone).
abstract class RecipientSearchRepository {
  /// Recherche des destinataires correspondant à [query].
  /// Retourne la liste des correspondances ou une liste vide si aucune.
  Future<List<RecipientMatch>> search(String query);
}
