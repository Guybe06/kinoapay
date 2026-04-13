import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";

/// Contrat d'accès aux contacts téléphoniques et à la résolution KinoaPay.
abstract class ContactsRepository {
  /// Retourne tous les contacts du téléphone enrichis de leur statut KinoaPay.
  Future<List<Contact>> getContacts();

  /// Filtre [contacts] selon [query] sur le nom ou le numéro de téléphone.
  List<Contact> search(List<Contact> contacts, String query);
}
