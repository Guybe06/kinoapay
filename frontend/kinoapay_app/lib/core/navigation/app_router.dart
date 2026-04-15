import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";
import "package:kinoapay_app/core/navigation/app_shell.dart";
import "package:kinoapay_app/core/navigation/route_transitions.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/accounts/presentation/forgot_password/forgot_password_otp_view.dart";
import "package:kinoapay_app/features/accounts/presentation/forgot_password/forgot_password_reset_view.dart";
import "package:kinoapay_app/features/accounts/presentation/forgot_password/forgot_password_view.dart";
import "package:kinoapay_app/features/onboarding/presentation/celebration/celebration_view.dart";
import "package:kinoapay_app/features/onboarding/presentation/payment_setup/payment_setup_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signin/signin_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_otp_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_view.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step2_view.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_bloc.dart";
import "package:kinoapay_app/features/contacts/infrastructure/repositories/phone_contacts_repository.dart";
import "package:kinoapay_app/features/contacts/presentation/contacts_view.dart";
import "package:kinoapay_app/features/notifications/application/bloc/notifications_bloc.dart";
import "package:kinoapay_app/features/notifications/infrastructure/repositories/mock_notifications_repository.dart";
import "package:kinoapay_app/features/notifications/presentation/notifications_view.dart";
import "package:kinoapay_app/features/receipt/presentation/receipt_view.dart";
import "package:kinoapay_app/features/scanner/presentation/scanner_view.dart";
import "package:kinoapay_app/features/splash/presentation/splash_view.dart";
import "package:kinoapay_app/features/welcome/domain/welcome_args.dart";
import "package:kinoapay_app/features/welcome/presentation/welcome_view.dart";

/// Résolution des routes nommées et génération des transitions.
class AppRouter {
  /// Détermine la route initiale selon l'état d'authentification et le setup canaux.
  static Future<String> resolveInitialRoute(
    SecureStorageService storage,
  ) async {
    final token = await storage.getToken();
    if (token != null && token.isNotEmpty) {
      if (!await storage.isChannelsSetupDone()) return AppRoutes.paymentSetup;
      return AppRoutes.shell;
    }
    if (!await storage.isFirstOpenApp()) return AppRoutes.signin;
    return AppRoutes.welcome;
  }

  /// Génère la route et sa transition selon le nom et les arguments fournis.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return RouteTransitions.fade(const SplashView(), settings);
      case AppRoutes.welcome:
        final wArgs = args is WelcomeArgs ? args : const WelcomeArgs();
        return RouteTransitions.hero(
          WelcomeView(fromSplash: wArgs.fromSplash),
          settings,
        );
      case AppRoutes.signin:
        return RouteTransitions.authStep(const SignInView(), settings);
      case AppRoutes.signup:
        return RouteTransitions.authStep(const SignUpStep1View(), settings);
      case AppRoutes.signupOtp:
        return RouteTransitions.authStep(const SignupOtpView(), settings);
      case AppRoutes.signupCredentials:
        return RouteTransitions.authStep(const SignUpStep2View(), settings);
      case AppRoutes.forgotPassword:
        return RouteTransitions.authStep(const ForgotPasswordView(), settings);
      case AppRoutes.forgotPasswordOtp:
        return RouteTransitions.authStep(
          const ForgotPasswordOtpView(),
          settings,
        );
      case AppRoutes.forgotPasswordReset:
        return RouteTransitions.authStep(
          const ForgotPasswordResetView(),
          settings,
        );
      case AppRoutes.celebration:
        return RouteTransitions.scaleUp(const CelebrationView(), settings);
      case AppRoutes.paymentSetup:
        return RouteTransitions.authStep(const PaymentSetupView(), settings);
      case AppRoutes.shell:
        final sArgs = args is ShellArgs ? args : const ShellArgs();
        return RouteTransitions.hero(AppShell(args: sArgs), settings);
      case AppRoutes.contacts:
        return RouteTransitions.slide(_contactsPage(), settings);
      case AppRoutes.notifications:
        return RouteTransitions.slide(_notificationsPage(), settings);
      case AppRoutes.receipt:
        return RouteTransitions.authStep(const ReceiptView(), settings);
      case AppRoutes.scanner:
        return RouteTransitions.slide(const ScannerView(), settings);
      default:
        return RouteTransitions.slide(_unknownPage(settings.name), settings);
    }
  }

  static Widget _contactsPage() => BlocProvider(
    create: (_) => ContactsBloc(repository: PhoneContactsRepository()),
    child: const ContactsView(),
  );

  static Widget _notificationsPage() => BlocProvider(
    create: (_) => NotificationsBloc(repository: MockNotificationsRepository()),
    child: const NotificationsView(),
  );

  static Widget _unknownPage(String? name) =>
      Scaffold(body: Center(child: Text(AppStrings.unknownRoute(name ?? ""))));
}
