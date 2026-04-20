import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";
import "package:kinoapay_app/features/send/domain/transaction_context.dart";

/// Arguments de navigation pour [SendView] en mode route nommée.
/// [prefilledContact] déclenche l'import automatique du contact dès l'ouverture.
/// [context] permet de lancer directement en mode paiement (depuis scan QR).
class SendArgs {
  final Contact? prefilledContact;
  final TransactionContext context;

  const SendArgs({
    this.prefilledContact,
    this.context = TransactionContext.send,
  });
}
