/// Routes nommées de l'application KinoaPay, toute navigation doit utiliser ces constantes, jamais de chaîne littérale.
class KinoaRoutes {
  // Démarrage
  static const String splash = "/";
  static const String welcome = "/welcome";
  // Authentification
  static const String signin = "/signin";
  static const String signup = "/signup";
  static const String signupOtp = "/signup-otp";
  static const String signupCredentials = "/signup-credentials";
  static const String forgotPassword = "/forgot-password";
  // Onboarding post-inscription
  static const String celebration = "/celebration";
  static const String kycAwareness = "/kyc-awareness";
  // Shell principal (avec header et bottom nav)
  static const String shell = "/app";
  // Onglets du shell (index pour IndexedStack)
  static const int tabDashboard = 0;
  static const int tabTransfer = 1;
  static const int tabHistory = 2;
  static const int tabProfile = 3;
  // Features accessibles depuis le shell
  static const String transfer = "/app/transfer";
  static const String history = "/app/history";
  static const String profile = "/app/profile";
  // Features P2P (accessibles via quick actions du dashboard)
  static const String moneyRequest = "/app/request";
  static const String split = "/app/split";
  static const String paymentLink = "/app/payment-link";
  static const String contacts = "/app/contacts";
  // Reçu et preuve ledger
  static const String receipt = "/app/receipt";
  static const String ledgerVerify = "/app/verify";
  // Notifications
  static const String notifications = "/app/notifications";
}
