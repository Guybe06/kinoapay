import "package:flutter_contacts/flutter_contacts.dart" as fc;
import "package:permission_handler/permission_handler.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";
import "package:kinoapay_app/features/contacts/domain/repositories/contacts_repository.dart";
import "package:kinoapay_app/features/contacts/infrastructure/users_seed.dart";

/// Lit le répertoire téléphonique et marque comme inscrits les numéros présents dans [usersByNormalizedPhone] (normalisés).
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
        final profile = usersByNormalizedPhone[normalized];

        contacts.add(
          Contact(
            id: pc.id,
            fullName: pc.displayName.isNotEmpty ? pc.displayName : normalized,
            phone: normalized,
            isRegistered: profile != null,
            publicHandle: profile?.publicHandle,
            channels: profile?.channels ?? const [],
          ),
        );
      }

      contacts.sort((a, b) {
        if (a.isRegistered != b.isRegistered) return a.isRegistered ? -1 : 1;
        return a.fullName.compareTo(b.fullName);
      });

      return contacts;
    } catch (_) {
      return [];
    }
  }

  @override
  List<Contact> search(List<Contact> contacts, String query) {
    final lower = query.toLowerCase();
    return contacts
        .where(
          (c) =>
              c.fullName.toLowerCase().contains(lower) ||
              c.phone.contains(lower),
        )
        .toList();
  }
}
