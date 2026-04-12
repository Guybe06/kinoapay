import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/navigation/kinoa_shell.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/splash/presentation/splash_view.dart";
import "package:kinoapay_app/features/welcome/presentation/welcome_view.dart";

/// Imports temporaires, seront remplacés par features/auth/ lors de la refonte auth.
import "package:kinoapay_app/features/accounts/presentation/signin/signin_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_view.dart";

/// Gère la résolution des routes et les transitions de navigation de l'application.
class KinoaRouter {
  /// Détermine la route initiale à afficher après le splash.
  /// @param storage  Service de stockage sécurisé pour lire le token
  /// @return         [KinoaRoutes.shell] si authentifié, [KinoaRoutes.welcome] sinon
  static Future<String> resolveInitialRoute(
    SecureStorageService storage,
  ) async {
    final token = await storage.getToken();
    return (token != null && token.isNotEmpty)
        ? KinoaRoutes.shell
        : KinoaRoutes.welcome;
  }

  /// Génère la route et sa transition selon le nom et les arguments fournis.
  /// @param settings  Nom de la route et arguments de navigation
  /// @return          Route avec la transition appropriée, ou route d'erreur si inconnue
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case KinoaRoutes.splash:
        return _fadeRoute(const SplashView(), settings);

      case KinoaRoutes.welcome:
        final wArgs = args is WelcomeArgs ? args : const WelcomeArgs();
        return _heroRoute(WelcomeView(fromSplash: wArgs.fromSplash), settings);

      case KinoaRoutes.signin:
        return _heroRoute(const SignInView(), settings);

      case KinoaRoutes.signup:
        return _heroRoute(const SignUpView(), settings);

      case KinoaRoutes.shell:
        final sArgs = args is ShellArgs ? args : const ShellArgs();
        return _heroRoute(KinoaShell(args: sArgs), settings);

      default:
        return _slideRoute(
          Scaffold(
            body: Center(child: Text("Route inconnue : ${settings.name}")),
          ),
          settings,
        );
    }
  }

  /// Construit une transition fondu simple, réservée au splash.
  /// @param page      Widget de destination
  /// @param settings  Paramètres de la route
  /// @return          PageRouteBuilder avec fondu 300ms
  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Construit une transition fondu longue, utilisée pour les routes depuis le splash.
  /// @param page      Widget de destination
  /// @param settings  Paramètres de la route
  /// @return          PageRouteBuilder avec fondu 500ms (laisse le Hero s'animer)
  static PageRouteBuilder _heroRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  /// Construit une transition glissement vertical bas vers haut, utilisée pour les routes internes.
  /// @param page      Widget de destination
  /// @param settings  Paramètres de la route
  /// @return          PageRouteBuilder avec fondu + slide 350ms
  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) {
        final slide =
            Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(position: slide, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}

/// Arguments transmis à [WelcomeView] lors de la navigation depuis le splash.
class WelcomeArgs {
  final bool fromSplash;

  /// @param fromSplash  true si la navigation provient du splash (active le Hero)
  const WelcomeArgs({this.fromSplash = false});
}

/// Arguments transmis aux pages d'authentification lors de la navigation depuis le splash.
class AuthArgs {
  final bool fromSplash;

  /// @param fromSplash  true si la navigation provient du splash (active le Hero)
  const AuthArgs({this.fromSplash = false});
}
