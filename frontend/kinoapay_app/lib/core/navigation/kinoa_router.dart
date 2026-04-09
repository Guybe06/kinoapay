import "package:flutter/material.dart";
import "package:kinoapay_app/features/accounts/presentation/signin/signin_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_view.dart";
import "package:kinoapay_app/features/home/presentation/home_view.dart";
import "package:kinoapay_app/features/splash/presentation/splash_view.dart";
import "package:kinoapay_app/features/welcome/presentation/welcome_view.dart";

/// Gère la configuration centralisée des routes et la logique de navigation de l'application.
class KinoaRouter {
  static const String splash = "/";
  static const String welcome = "/welcome";
  static const String signin = "/signin";
  static const String signup = "/signup";
  static const String home = "/home";

  /// Stocke le nom de la dernière route visitée qui n'est pas une page d'authentification.
  static String? previousRoute;

  /// Observateur personnalisé pour suivre l'historique de navigation.
  static final NavigatorObserver observer = _KinoaNavigatorObserver();

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashView(),
    welcome: (context) => const WelcomeView(),
    signin: (context) => const SignInView(),
    signup: (context) => const SignUpView(),
    home: (context) => const HomeView(),
  };

  /// Analyse les paramètres de navigation et retourne la route correspondante.
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }
    return null;
  }
}

/// Observateur privé pour mettre à jour la route précédente.
class _KinoaNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updatePrevious(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _updatePrevious(oldRoute);
  }

  void _updatePrevious(Route<dynamic>? route) {
    final name = route?.settings.name;
    // On n'enregistre pas les pages d'auth ou splash comme "précédentes" pour le retour post-login
    if (name != null && 
        name != KinoaRouter.signin && 
        name != KinoaRouter.signup && 
        name != KinoaRouter.splash) {
      KinoaRouter.previousRoute = name;
    }
  }
}
