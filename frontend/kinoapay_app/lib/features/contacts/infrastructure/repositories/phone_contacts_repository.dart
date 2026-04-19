import "package:flutter_contacts/flutter_contacts.dart" as fc;
import "package:permission_handler/permission_handler.dart";
import "package:kinoapay_app/core/constants/supported_countries.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";
import "package:kinoapay_app/features/contacts/domain/repositories/contacts_repository.dart";
import "package:kinoapay_app/features/contacts/infrastructure/users_seed.dart";

/// Lit le répertoire téléphonique et marque comme inscrits les numéros présents dans [usersByNormalizedPhone] (normalisés).
/// Cache statique en mémoire : les contacts ne sont lus qu'une seule fois par session.
/// Appeler [clearCache] pour forcer un rechargement (ex. pull-to-refresh).
class PhoneContactsRepository implements ContactsRepository {
  static List<Contact>? _cache;

  /// Vide le cache pour forcer le rechargement au prochain appel de [getContacts].
  static void clearCache() => _cache = null;

  /// Sépare un numéro normalisé en (dialCode, localNumber) depuis [SupportedCountries].
  /// Retourne ("", phone) si le pays n'est pas supporté.
  static ({String dialCode, String localNumber}) _splitPhone(String phone) {
    for (final country in SupportedCountries.all) {
      if (phone.startsWith(country.dialCode)) {
        return (
          dialCode: country.dialCode,
          localNumber: phone.substring(country.dialCode.length),
        );
      }
    }
    return (dialCode: "", localNumber: phone);
  }

  @override
  Future<List<Contact>> getContacts() async {
    if (_cache != null) return _cache!;

    try {
      final status = await Permission.contacts.request();
      if (!status.isGranted) return [];

      final phoneContacts = await fc.FlutterContacts.getAll(
        properties: {fc.ContactProperty.phone},
      );

      final contacts = <Contact>[];

      for (final pc in phoneContacts) {
        if (pc.phones.isEmpty) continue;

        final rawNumber = pc.phones.first.number.toString();
        if (rawNumber.isEmpty) continue;

        final normalized = normalizePhone(rawNumber);
        final profile = usersByNormalizedPhone[normalized];
        final displayName = pc.displayName.toString();

        final split = _splitPhone(normalized);
        contacts.add(
          Contact(
            id: pc.id.toString(),
            fullName: displayName.isNotEmpty ? displayName : normalized,
            phone: normalized,
            dialCode: split.dialCode,
            localNumber: split.localNumber,
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

      _cache = contacts;
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
