import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";

/// Arguments de navigation pour [SendView] en mode route nommée.
/// [prefilledContact] déclenche l'import automatique du contact dès l'ouverture.
class SendArgs {
  final Contact? prefilledContact;

  const SendArgs({this.prefilledContact});
}
