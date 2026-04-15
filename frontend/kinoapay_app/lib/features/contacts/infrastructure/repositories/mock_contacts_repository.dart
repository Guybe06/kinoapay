import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";
import "package:kinoapay_app/features/contacts/domain/repositories/contacts_repository.dart";

/// Numéros considérés comme inscrits, alignés sur les mocks de transactions.
const Set<String> _kinoaNumbers = {
  "+242066667788", // Jean Dupont
  "+242055554433", // Marie Claire
  "+242066660011", // Paul Mbengue
  "+242055559999", // Karim Idriss
  "+242066661122", // Fatou Diallo
  "+242055558877", // Grace Mikobi
  "+242066663344", // Théo Nganga
  "+242066665566", // Alain Bossou
};

/// Simule un répertoire importé : 8 numéros inscrits et 5 non inscrits.
const List<({String id, String name, String phone})> _phoneBook = [
  (id: "c001", name: "Jean Dupont",       phone: "+242066667788"),
  (id: "c002", name: "Marie Claire",      phone: "+242055554433"),
  (id: "c003", name: "Paul Mbengue",      phone: "+242066660011"),
  (id: "c004", name: "Karim Idriss",      phone: "+242055559999"),
  (id: "c005", name: "Fatou Diallo",      phone: "+242066661122"),
  (id: "c006", name: "Grace Mikobi",      phone: "+242055558877"),
  (id: "c007", name: "Théo Nganga",       phone: "+242066663344"),
  (id: "c008", name: "Alain Bossou",      phone: "+242066665566"),
  (id: "c009", name: "Prisca Moukala",    phone: "+242055531122"),
  (id: "c010", name: "Bernard Okoko",     phone: "+242066712345"),
  (id: "c011", name: "Sandra Louzolo",    phone: "+242055498765"),
  (id: "c012", name: "Eric Mayela",       phone: "+242066834567"),
  (id: "c013", name: "Rosalie Ntsoumou", phone: "+242055678901"),
];

class MockContactsRepository implements ContactsRepository {
  @override
  Future<List<Contact>> getContacts() async {
    await Future.delayed(const Duration(milliseconds: 700));

    final contacts = _phoneBook.map((e) {
      final onApp = _kinoaNumbers.contains(e.phone);
      return Contact(
        id: e.id,
        fullName: e.name,
        phone: e.phone,
        isOnKinoaPay: onApp,
        kinoaId: onApp ? e.phone : null,
      );
    }).toList();

    contacts.sort((a, b) {
      if (a.isOnKinoaPay != b.isOnKinoaPay) {
        return a.isOnKinoaPay ? -1 : 1;
      }
      return a.fullName.compareTo(b.fullName);
    });

    return contacts;
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
