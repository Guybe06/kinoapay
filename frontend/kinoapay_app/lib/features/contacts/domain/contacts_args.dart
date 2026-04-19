/// Arguments de navigation pour la vue Contacts.
class ContactsArgs {
  /// Si vrai, un tap sur un contact inscrit le renvoie via [Navigator.pop].
  final bool selectionMode;

  const ContactsArgs({this.selectionMode = false});
}
