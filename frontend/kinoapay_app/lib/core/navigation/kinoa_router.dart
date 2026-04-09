import "package:flutter/material.dart";
import "package:kinoapay_app/features/accounts/presentation/signin/signin_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_view.dart";
import "package:kinoapay_app/features/home/presentation/home_view.dart";
import "package:kinoapay_app/features/welcome/presentation/welcome_view.dart";

/// Gère la configuration centralisée des routes et la logique de navigation de l'application.
class KinoaRouter {
  static const String welcome = "/";
  static const String signin = "/signin";
  static const String signup = "/signup";
  static const String home = "/home";

  static Map<String, WidgetBuilder> get routes => {
    welcome: (context) => const WelcomeView(),
    signin: (context) => const SignInView(),
    signup: (context) => const SignUpView(),
    home: (context) => const HomeView(),
  };

  /// Analyse les paramètres de navigation et retourne la route correspondante ou null si non trouvée.
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }
    return null;
  }
}
