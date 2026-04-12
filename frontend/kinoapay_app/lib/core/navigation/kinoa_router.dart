import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/navigation/kinoa_shell.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/accounts/presentation/onboarding/celebration_view.dart";
import "package:kinoapay_app/features/accounts/presentation/onboarding/kyc_awareness_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signin/signin_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_otp_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step2_view.dart";
import "package:kinoapay_app/features/splash/presentation/splash_view.dart";
import "package:kinoapay_app/features/welcome/presentation/welcome_view.dart";

/// Gère la résolution des routes et les transitions de navigation de l'application.
class KinoaRouter {
  /// Détermine la route initiale après le splash selon l'état d'authentification.
  /// token présent → shell, first_open_app sans token → signin, jamais ouvert → welcome.
  static Future<String> resolveInitialRoute(SecureStorageService storage) async {
    final token = await storage.getToken();
    if (token != null && token.isNotEmpty) return KinoaRoutes.shell;
    if (!await storage.isFirstOpenApp()) return KinoaRoutes.signin;
    return KinoaRoutes.welcome;
  }

  /// Génère la route et sa transition selon le nom et les arguments fournis.
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
        return _heroRoute(const SignUpStep1View(), settings);

      case KinoaRoutes.signupOtp:
        return _heroRoute(const SignupOtpView(), settings);

      case KinoaRoutes.signupCredentials:
        return _heroRoute(const SignUpStep2View(), settings);

      case KinoaRoutes.celebration:
        return _heroRoute(const CelebrationView(), settings);

      case KinoaRoutes.kycAwareness:
        return _heroRoute(const KycAwarenessView(), settings);

      case KinoaRoutes.shell:
        final sArgs = args is ShellArgs ? args : const ShellArgs();
        return _heroRoute(KinoaShell(args: sArgs), settings);

      default:
        return _slideRoute(
          Scaffold(body: Center(child: Text("Route inconnue : ${settings.name}"))),
          settings,
        );
    }
  }

  // Fondu court, réservé au splash.
  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) =>
          FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn), child: child),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Fondu long, laisse le Hero s'animer librement.
  static PageRouteBuilder _heroRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) =>
          FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  // Slide bas → haut avec fondu, utilisé pour les routes internes.
  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) {
        final slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
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
  const WelcomeArgs({this.fromSplash = false});
}

/// Arguments transmis aux pages d'authentification lors de la navigation depuis le splash.
class AuthArgs {
  final bool fromSplash;
  const AuthArgs({this.fromSplash = false});
}
