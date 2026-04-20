/// Chaînes de caractères pour la feature Support.
abstract final class SupportStrings {
  static const String backLabel = "Plus";

  static const String helpPageTitle = "On est là.";
  static const String helpPageSubtitle =
      "Trouvez une réponse en quelques secondes.";
  static const String helpHeaderSubtitle = "Questions fréquentes";
  static const String helpTitle = "Centre d'aide";

  static const String contactPageTitle = "On vous aide.";
  static const String contactPageSubtitle = "Notre équipe est à votre écoute.";
  static const String contactHeaderSubtitle = "Support disponible";
  static const String contactTitle = "Support";
  static const String contactSectionEmail = "EMAIL";
  static const String contactEmail = "support@kinoapay.com";
  static const String contactEmailCopied = "Email copié !";
  static const String contactSectionWhatsapp = "WHATSAPP";
  static const String contactWhatsapp = "WhatsApp Support";
  static const String contactWhatsappDesc = "Réponse sous 24h";
  static const String contactWhatsappUrl = "https://wa.me/2424525687";
  static const String contactSectionHours = "DISPONIBILITÉ";
  static const String contactHours = "Lun – Sam  ·  8h – 20h (WAT)";

  static const String reportPageTitle = "Dites-nous tout.";
  static const String reportPageSubtitle = "Aidez-nous à améliorer l'app.";
  static const String reportHeaderSubtitle = "Signaler un problème";
  static const String reportTitle = "Signalement";
  static const String reportSectionCategory = "CATÉGORIE";
  static const String reportSectionMessage = "DESCRIPTION";
  static const String reportMessageHint = "Décrivez le problème en détail…";
  static const String reportSubmit = "Envoyer le signalement";
  static const String reportSuccess = "Signalement envoyé, merci !";

  static const List<String> reportCategories = [
    "Bug / Erreur technique",
    "Problème de paiement",
    "Problème de compte",
    "Autre",
  ];

  static const List<List<String>> faqItems = [
    [
      "Comment envoyer de l'argent ?",
      "Ouvrez l'app et appuyez sur Envoyer. Entrez le KinoaID ou scannez le QR du destinataire, saisissez le montant, puis confirmez. KinoaPay route le paiement automatiquement.",
    ],
    [
      "Quels opérateurs sont supportés ?",
      "MTN et Airtel (Congo-Brazzaville) sont disponibles au lancement. D'autres canaux seront ajoutés progressivement.",
    ],
    [
      "Combien coûte un transfert ?",
      "KinoaPay prélève entre 0,5 % et 1 % du montant routé. Le détail des frais est toujours affiché avant confirmation.",
    ],
    [
      "Qu'est-ce que le KinoaID ?",
      "Le KinoaID est votre identifiant unique sur KinoaPay (ex. @jean.dupont). Partagez-le pour recevoir des paiements sans communiquer votre numéro de téléphone.",
    ],
    [
      "Mon argent est-il stocké chez KinoaPay ?",
      "Non. KinoaPay ne détient aucun fonds. Votre argent transite directement de votre mobile money vers celui du destinataire.",
    ],
    [
      "Comment vérifier mon identité (KYC) ?",
      "Rendez-vous dans Plus › Vérification KYC › Mon Profil. La vérification Tier 1 requiert une pièce d'identité et prend moins de 5 minutes.",
    ],
    [
      "Un transfert a échoué, que faire ?",
      "Vérifiez votre solde opérateur et la connexion réseau. Si le problème persiste, contactez notre support via Plus › Contacter le support.",
    ],
  ];
}
