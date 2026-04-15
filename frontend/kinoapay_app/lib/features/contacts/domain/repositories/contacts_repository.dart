import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";

/// Accès au répertoire téléphonique et résolution du statut d'inscription.
abstract class ContactsRepository {
  /// Tous les contacts du téléphone enrichis du statut inscrit / non inscrit.
  Future<List<Contact>> getContacts();

  /// Filtre [contacts] selon [query] sur le nom ou le numéro de téléphone.
  List<Contact> search(List<Contact> contacts, String query);
}
