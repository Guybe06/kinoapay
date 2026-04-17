/// Chaînes de l'interface Dashboard.
abstract final class DashboardStrings {
  static const String greetingPrefix = "Bienvenue,";
  static const String fallbackName = "—";

  static const String actionSend = "ENVOYER";
  static const String actionRequest = "DEMANDER";
  static const String seeAll = "Voir tout";
  static const String seeMore = "Voir plus";

  static const String statsMonthlyTitle = "Activité mensuelle";
  static const String balanceLabel = "Solde de transactions";
  static const String statsIncoming = "Entrant";
  static const String statsOutgoing = "Sortant";
  static const String statsLegendReceived = "Reçu";
  static const String statsLegendSent = "Envoyé";
  static const String statsLast30 = "30 derniers jours";
  static const String statsCurrency = "XAF";

  static const String promoTitle = "Transférez partout,\nsans friction";
  static const String promoSubtitle =
      "Envoyez et recevez de l'argent en quelques secondes.";
  static const String promoCta = "En savoir plus";
  static const String promoLink = "Le lien entre tous vos comptes";
  static const String promoLinkDesc =
      "kinoaPay fait le pont entre vos comptes Mobile Money et vos banques. Vous n'avez pas besoin de créer un nouveau compte ou d'y stocker de l'argent : nous faisons simplement en sorte que vos comptes se parlent enfin.";
  static const String promoIdentity = "Une identité unique pour tout recevoir";
  static const String promoIdentityDesc =
      "Avec votre KinoaID, recevoir de l'argent devient un jeu d'enfant. Ne donnez plus vos numéros de téléphone ou vos coordonnées bancaires à tout le monde. Un seul identifiant suffit pour recevoir vos fonds directement là où vous le souhaitez.";
  static const String promoProof = "Un reçu numérique qui ne ment jamais";
  static const String promoProofDesc =
      "Chaque transaction est protégée par une preuve numérique infalsifiable. C'est une garantie que personne ne peut contester : votre argent est suivi à la trace et arrive toujours à bon port, avec une transparence totale.";
  static const String promoIntel = "L'intelligence qui évite les attentes";
  static const String promoIntelDesc =
      "Notre système surveille la santé des réseaux en temps réel. Si un opérateur ralentit ou tombe en panne, kinoaPay le voit instantanément et trouve automatiquement un chemin plus rapide pour que votre transfert reste immédiat.";
  static const String promoFooter =
      "kinoaPay ne change pas vos habitudes, il les simplifie en connectant vos moyens de paiement préférés sous une protection universelle.";

  static const String recentContacts = "Contacts récents";
  static const String addContact = "Ajouter";
  static const String lastTx = "Dernières transactions";
  static const String noTx = "Aucune transaction récente";

  static const String txSent = "Envoyé";
  static const String txReceived = "Reçu";
  static const String txPending = "En attente";
  static const String txProcessing = "En traitement";
  static const String txFailed = "Échoué";
  static const String txJustNow = "À l'instant";
  static String txMinutesAgo(int m) => "il y a $m min";
  static String txToday(String hhmm) => "Aujourd'hui $hhmm";
  static String txYesterday(String hhmm) => "Hier $hhmm";
  static const String txAml = "AML";
  static const String txNet = "net";

  static const String channelSection = "Par canal";
  static String txCountLabel(int n) => "$n transaction${n > 1 ? "s" : ""}";

  static const String quickActionsTitle = "Actions rapides";
  static const String quickAdd = "Ajouter";
  static const String quickSend = "Envoyer";
  static const String quickConvert = "Convertir";
  static const String quickMore = "Plus";

  static const String errorLoad =
      "Impossible de charger les données du tableau de bord";
  static const String errorRefresh = "Échec du rafraîchissement des données";
}
