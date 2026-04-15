import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/navigation/nav_throttle.dart";
import "package:kinoapay_app/core/navigation/app_router.dart";
import "package:kinoapay_app/core/network/dio_client.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/core/theme/app_theme.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/payment_setup_bloc.dart";
import "package:kinoapay_app/features/accounts/infrastructure/repositories/mock_auth_repository.dart";
import "package:kinoapay_app/features/accounts/infrastructure/repositories/mock_payment_channel_repository.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/infrastructure/repositories/mock_dashboard_repository.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/infrastructure/repositories/mock_send_repository.dart";

/// Observer global de navigation, utilisé par [StaggeredEntrance] pour rejouer les animations au retour.
final RouteObserver<ModalRoute<void>> appRouteObserver = RouteObserver<ModalRoute<void>>();

/// Point d'entrée : initialisation des dépendances globales puis [runApp].
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("fr_FR", null);

  const storage = SecureStorageService();

  // ignore: unused_local_variable, sera injecté dans les repositories HTTP lors de la refonte auth.
  final dioClient = DioClient(
    baseUrl: "https://api.kinoapay.com",
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
      child: const RootApp(),
    ),
  );
}

/// Widget racine [MaterialApp] : thème clair global ; [WelcomeView] conserve un fond sombre local.
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
