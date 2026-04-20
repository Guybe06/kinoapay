/// Routes nommées : navigation exclusivement via ces constantes, jamais de chaîne littérale.
abstract final class AppRoutes {
  static const String splash = "/";
  static const String welcome = "/welcome";
  static const String signin = "/signin";
  static const String signup = "/signup";
  static const String signupOtp = "/signup-otp";
  static const String signupCredentials = "/signup-credentials";
  static const String forgotPassword = "/forgot-password";
  static const String forgotPasswordOtp = "/forgot-password-otp";
  static const String forgotPasswordReset = "/forgot-password-reset";
  static const String celebration = "/celebration";
  static const String paymentSetup = "/payment-setup";
  static const String shell = "/app";
  static const String contacts = "/app/contacts";
  static const String notifications = "/app/notifications";
  static const String scanner = "/app/scanner";
  static const String profile = "/app/profile";
  static const String history = "/app/history";
  static const String send = "/app/send";
  static const String channels = "/app/channels";
  static const String request = "/app/request";

  static const int tabDashboard = 0;
  static const int tabTransfer = 1;
  static const int tabMore = 2;
}
