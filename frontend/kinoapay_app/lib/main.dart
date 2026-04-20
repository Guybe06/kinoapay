import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/navigation/nav_throttle.dart";
import "package:kinoapay_app/core/navigation/app_router.dart";
import "package:kinoapay_app/core/navigation/route_observer.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/core/theme/app_theme.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/onboarding/application/bloc/payment_setup_bloc.dart";
import "package:kinoapay_app/features/accounts/infrastructure/repositories/mock_auth_repository.dart";
import "package:kinoapay_app/features/accounts/infrastructure/repositories/mock_payment_channel_repository.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/infrastructure/repositories/mock_dashboard_repository.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/infrastructure/repositories/mock_recipient_search_repository.dart";
import "package:kinoapay_app/features/send/infrastructure/repositories/mock_send_repository.dart";

/// Point d'entrée : initialisation des dépendances globales puis [runApp].
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("fr_FR", null);

  const storage = SecureStorageService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) {
            final bloc = AuthBloc(
              repository: MockAuthRepository(storage: storage),
              storage: storage,
            );
            bloc.add(const AuthSessionRestoreRequested());
            return bloc;
          },
        ),
        BlocProvider<DashboardBloc>(
          create: (_) =>
              DashboardBloc(dashboardRepository: MockDashboardRepository()),
        ),
        BlocProvider<SendBloc>(
          create: (_) => SendBloc(
            repository: MockSendRepository(),
            searchRepository: MockRecipientSearchRepository(),
          ),
        ),
        BlocProvider<PaymentSetupBloc>(
          create: (_) => PaymentSetupBloc(
            repo: MockPaymentChannelRepository(storage: storage),
          ),
        ),
      ],
      child: const RootApp(),
    ),
  );
}

/// Clé globale du navigateur : permet au [BlocListener] racine de déclencher
/// la navigation vers signin sans dépendre d'un [BuildContext] local.
final _navigatorKey = GlobalKey<NavigatorState>();

/// Widget racine [MaterialApp] : thème clair global ; [WelcomeView] conserve un fond sombre local.
/// Un [BlocListener] global écoute [Unauthenticated] pour rediriger vers signin
/// depuis n'importe quel écran de l'application.
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          _navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.signin,
            (_) => false,
          );
        }
      },
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.light,
        locale: const Locale("fr"),
        supportedLocales: const [Locale("fr"), Locale("en")],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        navigatorObservers: [appRouteObserver, NavThrottle()],
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
