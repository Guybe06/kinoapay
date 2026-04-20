/// Catégorie d'un participant à une transaction KinoaPay.
/// Source de vérité unique — utilisée dans [RecipientMatch] et [Transaction].
enum KinoaUserType {
  /// Utilisateur inscrit sur l'app KinoaPay (KYC vérifié).
  individual,

  /// Profil marchand créé sur KinoaWeb (KYC vérifié, sans app).
  merchant,

  /// Numéro mobile money non inscrit sur KinoaPay.
  external,
}

extension KinoaUserTypeX on KinoaUserType {
  /// Vrai si le participant a un compte KinoaPay (individuel ou marchand).
  bool get isOnKinoa => this != KinoaUserType.external;

  /// Label du badge affiché dans les listes de transactions.
  /// Null pour [individual] — la cohérence visuelle suffit, pas de badge.
  String? get badgeLabel => switch (this) {
        KinoaUserType.merchant => "Marchand",
        KinoaUserType.external => "Externe",
        KinoaUserType.individual => null,
      };
}
