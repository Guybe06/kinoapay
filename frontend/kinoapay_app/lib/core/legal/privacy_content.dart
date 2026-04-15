/// Textes de la politique de confidentialité (titres et corps) pour affichage structuré.
abstract final class PrivacyContent {
  static const String title = "Politique de Confidentialité";
  static const String version = "Version 1.0, Avril 2026";
  static const String controller = "Responsable du traitement : Winsa Ltd, Brazzaville, République du Congo";

  static const String a1Title = "1. Données collectées";
  static const String a1Body =
      "Dans le cadre de l'utilisation de kinoaPay, Winsa Ltd collecte les catégories "
      "de données suivantes :\n\n"
      "Données d'identité : nom, prénom, date de naissance, numéro de pièce d'identité "
      "nationale ou passeport (collectés dans le cadre du processus KYC).\n\n"
      "Données de contact : numéro de téléphone mobile, adresse e-mail.\n\n"
      "Données financières : numéros de comptes Mobile Money ou bancaires liés au compte "
      "kinoaPay, historique complet des transactions enregistrées dans le KinoaLedger.\n\n"
      "Données techniques : adresse IP, type d'appareil, système d'exploitation, "
      "version de l'application, identifiant de session, journaux d'activité.";

  static const String a2Title = "2. Finalités du traitement";
  static const String a2Body =
      "Les données personnelles collectées sont traitées aux fins suivantes :\n"
      "exécution et sécurisation des transactions financières ; vérification d'identité "
      "et conformité KYC/KYB ; prévention de la fraude et conformité aux obligations "
      "réglementaires (BEAC, COBAC, dispositif LBC/FT) ; amélioration continue du service "
      "et analyse des usages de façon agrégée et anonymisée ; communication avec "
      "l'utilisateur concernant son compte, ses transactions et les évolutions du service.";

  static const String a3Title = "3. Base légale";
  static const String a3Body =
      "Le traitement de vos données repose sur les bases légales suivantes : "
      "l'exécution du contrat de service formalisé par l'acceptation des CGU ; "
      "le respect des obligations légales et réglementaires applicables à Winsa Ltd "
      "(notamment les règlements BEAC et COBAC relatifs aux établissements de paiement) ; "
      "le consentement explicite de l'utilisateur pour les communications à caractère "
      "non essentiel (notifications marketing, enquêtes de satisfaction).";

  static const String a4Title = "4. Conservation des données";
  static const String a4Body =
      "Les données sont conservées pendant toute la durée de la relation contractuelle. "
      "À la clôture du compte, les données sont conservées pour les durées légales "
      "applicables en matière financière et de lutte contre le blanchiment (généralement "
      "5 à 10 ans selon la nature de l'opération, conformément aux textes CEMAC). "
      "Les données du KinoaLedger relatives aux transactions validées sont conservées "
      "de façon permanente sous forme cryptographique anonymisée à des fins d'intégrité "
      "du registre. À l'issue de tous les délais légaux, les données à caractère personnel "
      "sont supprimées ou rendues définitivement anonymes.";

  static const String a5Title = "5. Partage des données";
  static const String a5Body =
      "Winsa Ltd ne vend ni ne loue les données personnelles de ses utilisateurs à des tiers. "
      "Les données peuvent être transmises dans les cas suivants :\n"
      "Opérateurs tiers (MTN Mobile Money, Airtel Money, établissements bancaires partenaires) : "
      "dans la stricte mesure nécessaire à l'exécution des transactions initiées par l'utilisateur.\n"
      "Autorités compétentes (BEAC, COBAC, autorités judiciaires congolaises ou internationales) : "
      "sur réquisition légale dûment formalisée, dans le respect du droit congolais applicable.\n"
      "Prestataires techniques de Winsa Ltd : sous contrat de confidentialité et dans le "
      "strict cadre de la prestation fournie (hébergement, sécurité, analyse).";

  static const String a6Title = "6. Sécurité";
  static const String a6Body =
      "kinoaPay applique un chiffrement de bout en bout (TLS 1.3 minimum) sur l'ensemble "
      "des communications entre l'application et les serveurs. Les données sensibles "
      "(identifiants de compte, tokens d'authentification) sont stockées de façon chiffrée "
      "sur l'appareil de l'utilisateur via un stockage sécurisé dédié. Les serveurs de "
      "Winsa Ltd sont hébergés dans des environnements sécurisés avec contrôle d'accès "
      "strict, journalisation des accès et surveillance continue. Seul le personnel "
      "habilité de Winsa Ltd, soumis à une obligation de confidentialité, accède aux "
      "données à caractère personnel.";

  static const String a7Title = "7. Droits de l'utilisateur";
  static const String a7Body =
      "Conformément aux textes applicables, l'utilisateur dispose des droits suivants "
      "sur ses données personnelles : droit d'accès, droit de rectification en cas "
      "d'inexactitude, droit à l'effacement (sous réserve des obligations légales de "
      "conservation), droit à la limitation du traitement, droit à la portabilité pour "
      "les données fournies sur la base du consentement ou du contrat.\n\n"
      "Ces droits s'exercent par demande écrite adressée à : privacy@kinoapay.com "
      "ou via la rubrique dédiée dans les paramètres de l'application. "
      "Winsa Ltd s'engage à répondre dans un délai de 30 jours ouvrés.";

  static const String a8Title = "8. Cookies et traceurs";
  static const String a8Body =
      "L'application mobile kinoaPay n'utilise pas de cookies publicitaires ni de "
      "traceurs de profilage commercial. Des traceurs techniques strictement nécessaires "
      "au bon fonctionnement du service (maintien de session, détection de fraude, "
      "mesure d'audience anonymisée) peuvent être utilisés ; ils ne requièrent pas de "
      "consentement préalable car indispensables à la fourniture du service.";

  static const String a9Title = "9. Modifications de la politique";
  static const String a9Body =
      "Winsa Ltd se réserve le droit de modifier la présente politique à tout moment, "
      "notamment pour se conformer aux évolutions législatives ou réglementaires. "
      "Toute modification significative est notifiée à l'utilisateur via l'application "
      "au moins 15 jours avant son entrée en vigueur. La version en vigueur est toujours "
      "accessible depuis les paramètres de l'application. La date de dernière mise à jour "
      "est indiquée en en-tête du document.";

  static const String a10Title = "10. Contact";
  static const String a10Body =
      "Pour toute question relative à la protection de vos données personnelles, "
      "ou pour exercer vos droits, contactez le responsable du traitement :\n\n"
      "Winsa Ltd — Délégué à la protection des données\n"
      "Brazzaville, République du Congo\n"
      "E-mail : privacy@kinoapay.com";

  static const String contactLabel = "Contact protection des données";
  static const String contactEmail = "privacy@kinoapay.com";
}
