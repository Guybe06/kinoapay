import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/repositories/recipient_search_repository.dart";

/// Utilisateur fictif interne pour l'implémentation mock de la recherche.
class _MockUser {
  final String kinoaId;
  final String name;
  final String phone;
  final List<PaymentChannel> channels;

  const _MockUser({
    required this.kinoaId,
    required this.name,
    required this.phone,
    required this.channels,
  });
}

/// Implémentation mock : recherche par préfixe d'ID Kinoa (après @) ou sous-chaîne de numéro.
class MockRecipientSearchRepository implements RecipientSearchRepository {
  static const Duration _latency = Duration(milliseconds: 800);
  static const String _idPrefix = "@";

  static const List<_MockUser> _users = [
    _MockUser(
      kinoaId: "956231",
      name: "Jean Dupont",
      phone: "06 444 55 66",
      channels: [
        PaymentChannel(
          id: "1",
          type: "MTN Mobile Money",
          label: "Principal",
          value: "06 444 55 66",
          short: "MTN",
          status: "active",
          txCount: 12,
        ),
        PaymentChannel(
          id: "2",
          type: "Airtel Money",
          label: "Secondaire",
          value: "04 111 22 33",
          short: "AIRTEL",
          status: "active",
          txCount: 5,
        ),
      ],
    ),
    _MockUser(
      kinoaId: "956847",
      name: "Lucas Moreau",
      phone: "05 123 45 67",
      channels: [
        PaymentChannel(
          id: "7",
          type: "Orange Money",
          label: "Perso",
          value: "05 123 45 67",
          short: "Orange",
          status: "active",
          txCount: 3,
        ),
      ],
    ),
    _MockUser(
      kinoaId: "956912",
      name: "Emma Dubois",
      phone: "06 888 99 00",
      channels: [
        PaymentChannel(
          id: "8",
          type: "MTN Mobile Money",
          label: "Perso",
          value: "06 888 99 00",
          short: "MTN",
          status: "active",
          txCount: 7,
        ),
      ],
    ),
    _MockUser(
      kinoaId: "847291",
      name: "Marie Curie",
      phone: "06 777 88 99",
      channels: [
        PaymentChannel(
          id: "3",
          type: "Orange Money",
          label: "Perso",
          value: "06 777 88 99",
          short: "Orange",
          status: "active",
          txCount: 8,
        ),
      ],
    ),
    _MockUser(
      kinoaId: "847563",
      name: "Thomas Petit",
      phone: "05 444 22 11",
      channels: [
        PaymentChannel(
          id: "9",
          type: "Airtel Money",
          label: "Pro",
          value: "05 444 22 11",
          short: "Airtel",
          status: "active",
          txCount: 12,
        ),
      ],
    ),
    _MockUser(
      kinoaId: "152847",
      name: "Pierre Martin",
      phone: "06 222 33 44",
      channels: [
        PaymentChannel(
          id: "4",
          type: "MTN Mobile Money",
          label: "Pro",
          value: "06 222 33 44",
          short: "MTN",
          status: "active",
          txCount: 23,
        ),
        PaymentChannel(
          id: "5",
          type: "Visa Card",
          label: "Carte",
          value: "•••• 4242",
          short: "Visa",
          status: "active",
          txCount: 0,
        ),
      ],
    ),
    _MockUser(
      kinoaId: "639482",
      name: "Sophie Bernard",
      phone: "05 555 66 77",
      channels: [
        PaymentChannel(
          id: "6",
          type: "Airtel Money",
          label: "Principal",
          value: "05 555 66 77",
          short: "Airtel",
          status: "active",
          txCount: 15,
        ),
      ],
    ),
  ];

  @override
  Future<List<RecipientMatch>> search(String query) async {
    await Future.delayed(_latency);
    final cleanQuery = _normalize(query);
    final isIdSearch = cleanQuery.startsWith(_idPrefix);
    final matches = _users.where((user) => _matches(user, cleanQuery, isIdSearch));
    return matches
        .map((u) => RecipientMatch(name: u.name, channels: u.channels))
        .toList();
  }

  /// Supprime les espaces pour faciliter la comparaison.
  String _normalize(String input) => input.replaceAll(" ", "");

  /// Évalue si [user] correspond à la requête selon le mode (ID ou téléphone).
  bool _matches(_MockUser user, String cleanQuery, bool isIdSearch) {
    if (isIdSearch) {
      final prefix = cleanQuery.substring(_idPrefix.length);
      return user.kinoaId.startsWith(prefix);
    }
    final cleanPhone = _normalize(user.phone);
    return cleanPhone.contains(cleanQuery);
  }
}
