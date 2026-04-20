/// Contexte d'une transaction initié par l'utilisateur.
/// Propagé de [ScanResult] jusqu'aux étapes finales du flow Send.
enum TransactionContext {
  /// Envoi classique initié par l'utilisateur (il choisit le destinataire).
  send,

  /// Paiement d'une demande reçue via QR ou lien (destinataire + montant pré-remplis).
  pay,
}

extension TransactionContextX on TransactionContext {
  bool get isPay => this == TransactionContext.pay;
  bool get isSend => this == TransactionContext.send;
}
