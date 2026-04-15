/// Chemins d'endpoints API : utilisation exclusive, sans littéraux dans les requêtes HTTP.
class KinoaApi {
  static const String _v1 = "/v1";

  static const String signup = "$_v1/accounts/signup";
  static const String signin = "$_v1/accounts/signin";
  static const String refresh = "$_v1/accounts/refresh";
  static const String signout = "$_v1/accounts/signout";
  static const String me = "$_v1/accounts/me";
  static const String createTransaction = "$_v1/client/transactions";
  static const String listTransactions = "$_v1/client/transactions";

  /// @param ktxid  Identifiant KinoaTx de la transaction
  /// @return       Chemin GET /v1/client/transactions/:ktxid
  static String transactionDetail(String ktxid) => "$_v1/client/transactions/$ktxid";

  /// @param ktxid  Identifiant KinoaTx de la transaction
  /// @return       Chemin GET /v1/client/receipts/:ktxid
  static String receipt(String ktxid) => "$_v1/client/receipts/$ktxid";

  static const String createRequest = "$_v1/client/requests";
  static const String listRequests = "$_v1/client/requests";

  /// @param requestId  Identifiant de la demande d'argent
  /// @return           Chemin POST /v1/client/requests/:requestId/respond
  static String respondToRequest(String requestId) =>
      "$_v1/client/requests/$requestId/respond";

  static const String createSplit = "$_v1/client/splits";
  static const String listSplits = "$_v1/client/splits";

  /// @param splitId  Identifiant du split
  /// @return         Chemin GET /v1/client/splits/:splitId
  static String splitDetail(String splitId) => "$_v1/client/splits/$splitId";

  /// @param splitId  Identifiant du split
  /// @return         Chemin POST /v1/client/splits/:splitId/pay
  static String paySplitPart(String splitId) => "$_v1/client/splits/$splitId/pay";

  static const String createPaymentLink = "$_v1/client/payment-links";
  static const String listPaymentLinks = "$_v1/client/payment-links";
  static const String listContacts = "$_v1/client/contacts";

  /// @param ref  Référence publique de la transaction
  /// @return     Chemin GET /v1/ledger/verify/:ref
  static String verifyTransaction(String ref) => "$_v1/ledger/verify/$ref";
}
