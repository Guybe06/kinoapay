import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";
import "package:kinoapay_app/core/navigation/kinoa_nav_throttle.dart";
import "package:kinoapay_app/core/navigation/kinoa_shell.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/accounts/presentation/onboarding/celebration_view.dart";
import "package:kinoapay_app/features/accounts/presentation/onboarding/kyc_awareness_view.dart";
import "package:kinoapay_app/features/accounts/presentation/onboarding/payment_setup_view.dart";
import "package:kinoapay_app/features/accounts/presentation/forgot_password/forgot_password_view.dart";
import "package:kinoapay_app/features/accounts/presentation/forgot_password/forgot_password_otp_view.dart";
import "package:kinoapay_app/features/accounts/presentation/forgot_password/forgot_password_reset_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signin/signin_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_otp_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step2_view.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_bloc.dart";
import "package:kinoapay_app/features/contacts/infrastructure/repositories/phone_contacts_repository.dart";
import "package:kinoapay_app/features/contacts/presentation/contacts_view.dart";
import "package:kinoapay_app/features/notifications/application/bloc/notifications_bloc.dart";
import "package:kinoapay_app/features/notifications/infrastructure/repositories/mock_notifications_repository.dart";
import "package:kinoapay_app/features/notifications/presentation/notifications_view.dart";
import "package:kinoapay_app/features/receipt/presentation/receipt_view.dart";
import "package:kinoapay_app/features/scanner/presentation/scanner_view.dart";
import "package:kinoapay_app/features/splash/presentation/splash_view.dart";
import "package:kinoapay_app/features/welcome/presentation/welcome_view.dart";

/// Résolution des routes nommées et transitions de navigation.
class KinoaRouter {
  /// Détermine la route initiale après le splash selon l'état d'authentification et le setup canaux.
  /// @return le nom de route [KinoaRoutes] à afficher
  static Future<String> resolveInitialRoute(SecureStorageService storage) async {
    final token = await storage.getToken();
    if (token != null && token.isNotEmpty) {
      if (!await storage.isChannelsSetupDone()) return KinoaRoutes.paymentSetup;
      return KinoaRoutes.shell;
    }
    if (!await storage.isFirstOpenApp()) return KinoaRoutes.signin;
    return KinoaRoutes.welcome;
  }

  /// Génère la route et sa transition selon le nom et les arguments fournis.
  /// @return la [Route] construite ou null si la navigation est temporairement bloquée
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (!KinoaNavThrottle.canNavigate) return null;
    final args = settings.arguments;

    switch (settings.name) {
      case KinoaRoutes.splash:
        return _fadeRoute(const SplashView(), settings);

      case KinoaRoutes.welcome:
        final wArgs = args is WelcomeArgs ? args : const WelcomeArgs();
        return _heroRoute(WelcomeView(fromSplash: wArgs.fromSplash), settings);

      case KinoaRoutes.signin:
        return _authStepRoute(const SignInView(), settings);

      case KinoaRoutes.signup:
        return _authStepRoute(const SignUpStep1View(), settings);

      case KinoaRoutes.signupOtp:
        return _authStepRoute(const SignupOtpView(), settings);

      case KinoaRoutes.signupCredentials:
        return _authStepRoute(const SignUpStep2View(), settings);

      case KinoaRoutes.forgotPassword:
        return _authStepRoute(const ForgotPasswordView(), settings);

      case KinoaRoutes.forgotPasswordOtp:
        return _authStepRoute(const ForgotPasswordOtpView(), settings);

      case KinoaRoutes.forgotPasswordReset:
        return _authStepRoute(const ForgotPasswordResetView(), settings);

      case KinoaRoutes.celebration:
        return _scaleUpRoute(const CelebrationView(), settings);

      case KinoaRoutes.kycAwareness:
        return _authStepRoute(const KycAwarenessView(), settings);

      case KinoaRoutes.paymentSetup:
        return _authStepRoute(const PaymentSetupView(), settings);

      case KinoaRoutes.shell:
        final sArgs = args is ShellArgs ? args : const ShellArgs();
        return _heroRoute(KinoaShell(args: sArgs), settings);

      case KinoaRoutes.contacts:
        return _slideRoute(
          BlocProvider(
            create: (_) => ContactsBloc(repository: PhoneContactsRepository()),
            child: const ContactsView(),
          ),
          settings,
        );

      case KinoaRoutes.notifications:
        return _slideRoute(
          BlocProvider(
            create: (_) => NotificationsBloc(repository: MockNotificationsRepository()),
            child: const NotificationsView(),
          ),
          settings,
        );

      case KinoaRoutes.receipt:
        return _authStepRoute(const ReceiptView(), settings);

      case KinoaRoutes.scanner:
        return _slideRoute(const ScannerView(), settings);

      default:
        return _slideRoute(
          Scaffold(body: Center(child: Text(KinoaStrings.unknownRoute(settings.name ?? "")))),
          settings,
        );
    }
  }

  /// Fondu court, réservé au splash.
  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) =>
          FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn), child: child),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Fondu long, laisse le Hero s'animer librement.
  static PageRouteBuilder _heroRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) =>
          FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  /// Glissement bas vers haut avec fondu, utilisé pour les routes internes (contacts, notifs…).
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

  /// Transition inter-étapes auth.
  /// Aller : slide droite→centre + fade in. Retour : slide centre→droite, sans fade.
  static PageRouteBuilder _authStepRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final isForward = animation.status == AnimationStatus.forward || animation.status == AnimationStatus.completed;

        if (!isForward) return child;

        final slide = Tween<Offset>(
          begin: const Offset(0.25, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

        final pushBack = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.15, 0),
        ).animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic));

        return SlideTransition(
          position: pushBack,
          child: SlideTransition(
            position: slide,
            child: FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Scale-up avec fondu, réservé aux écrans de célébration / succès.
  static PageRouteBuilder _scaleUpRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved), child: child),
        );
      },
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
