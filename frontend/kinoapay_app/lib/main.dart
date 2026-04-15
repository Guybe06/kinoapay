import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/navigation/kinoa_nav_throttle.dart";
import "package:kinoapay_app/core/navigation/kinoa_router.dart";
import "package:kinoapay_app/core/network/dio_client.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/core/theme/kinoa_theme.dart";
import "package:kinoapay_app/core/theme/theme_notifier.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/payment_setup_bloc.dart";
import "package:kinoapay_app/features/accounts/infrastructure/repositories/mock_auth_repository.dart";
import "package:kinoapay_app/features/accounts/infrastructure/repositories/mock_payment_channel_repository.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/infrastructure/repositories/mock_dashboard_repository.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/infrastructure/repositories/mock_send_repository.dart";

/// Notifier global du thème, accessible depuis n'importe quel widget via [themeNotifier].
final ThemeNotifier themeNotifier = ThemeNotifier();

/// Observer global de navigation, utilisé par [KinoaEntrance] pour rejouer les animations au retour.
final RouteObserver<ModalRoute<void>> kinoaRouteObserver = RouteObserver<ModalRoute<void>>();

/// Point d'entrée principal : initialise les dépendances globales et lance l'application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("fr_FR", null);

  const storage = SecureStorageService();

  // ignore: unused_local_variable, sera injecté dans les repositories HTTP lors de la refonte auth.
  final dioClient = DioClient(
    baseUrl: "https://api.kinoaPay.com",
    storage: storage,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) {
            final bloc = AuthBloc(repository: MockAuthRepository(storage: storage), storage: storage);
            bloc.add(const AuthSessionRestoreRequested());
            return bloc;
          },
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc(dashboardRepository: MockDashboardRepository()),
        ),
        BlocProvider<SendBloc>(
          create: (_) => SendBloc(repository: MockSendRepository()),
        ),
        BlocProvider<PaymentSetupBloc>(
          create: (_) => PaymentSetupBloc(
            repo: MockPaymentChannelRepository(storage: storage),
          ),
        ),
      ],
      child: const KinoaPayApp(),
    ),
  );
}

/// Racine de l'application : écoute [ThemeNotifier] et reconstruit le thème à chaque changement.
class KinoaPayApp extends StatelessWidget {
  const KinoaPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        return MaterialApp(
          title: "KinoaPay",
          debugShowCheckedModeBanner: false,
          theme: KinoaTheme.light(),
          darkTheme: KinoaTheme.dark(),
          themeMode: mode,
          locale: const Locale("fr"),
          supportedLocales: const [Locale("fr"), Locale("en")],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorObservers: [kinoaRouteObserver, KinoaNavThrottle()],
          initialRoute: KinoaRoutes.splash,
          onGenerateRoute: KinoaRouter.generateRoute,
        );
      },
    );
  }
}
