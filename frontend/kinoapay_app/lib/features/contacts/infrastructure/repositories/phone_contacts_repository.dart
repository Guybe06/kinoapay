import "package:flutter_contacts/flutter_contacts.dart" as fc;
import "package:permission_handler/permission_handler.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";
import "package:kinoapay_app/features/contacts/domain/repositories/contacts_repository.dart";
import "package:kinoapay_app/features/contacts/infrastructure/kinoa_users_database.dart";

/// Lit les contacts du répertoire téléphonique et détecte ceux inscrits sur KinoaPay
/// en comparant les numéros normalisés à [kinoaUsersDatabase].
class PhoneContactsRepository implements ContactsRepository {
  @override
  Future<List<Contact>> getContacts() async {
    try {
      final status = await Permission.contacts.request();
      if (!status.isGranted) return [];

      final phoneContacts = await fc.FlutterContacts.getContacts(
        withProperties: true,
      );

      final contacts = <Contact>[];

      for (final pc in phoneContacts) {
        if (pc.phones.isEmpty) continue;

        final normalized = normalizePhone(pc.phones.first.number);
        final profile = kinoaUsersDatabase[normalized];

        contacts.add(Contact(
          id: pc.id,
          fullName: pc.displayName.isNotEmpty ? pc.displayName : normalized,
          phone: normalized,
          isOnKinoaPay: profile != null,
          kinoaId: profile?.kinoaId,
          channels: profile?.channels ?? const [],
        ));
      }

      // Contacts KinoaPay en premier, puis ordre alphabétique dans chaque groupe.
      contacts.sort((a, b) {
        if (a.isOnKinoaPay != b.isOnKinoaPay) return a.isOnKinoaPay ? -1 : 1;
        return a.fullName.compareTo(b.fullName);
      });

      return contacts;
    } catch (e) {
      // ignore: avoid_print
      print("Exception dans PhoneContactsRepository: $e");
      return [];
    }
  }

  @override
  List<Contact> search(List<Contact> contacts, String query) {
    final lower = query.toLowerCase();
    return contacts
        .where((c) =>
            c.fullName.toLowerCase().contains(lower) ||
            c.phone.contains(lower))
        .toList();
  }
}
