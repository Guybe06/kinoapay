/// Pays supportés par l'application avec code ISO, drapeau, nom et indicatif téléphonique.
abstract final class SupportedCountries {
  static const List<({String iso, String flag, String name, String dialCode})> all = [
    (iso: "CG", flag: "🇨🇬", name: "Congo-Brazzaville", dialCode: "+242"),
    (iso: "CD", flag: "🇨🇩", name: "Congo-Kinshasa", dialCode: "+243"),
    (iso: "GA", flag: "🇬🇦", name: "Gabon", dialCode: "+241"),
    (iso: "CM", flag: "🇨🇲", name: "Cameroun", dialCode: "+237"),
    (iso: "CF", flag: "🇨🇫", name: "Centrafrique", dialCode: "+236"),
    (iso: "TD", flag: "🇹🇩", name: "Tchad", dialCode: "+235"),
    (iso: "GQ", flag: "🇬🇶", name: "Guinée Équatoriale", dialCode: "+240"),
    (iso: "AO", flag: "🇦🇴", name: "Angola", dialCode: "+244"),
  ];
}
