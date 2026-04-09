import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:google_fonts/google_fonts.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/navigation/kinoa_router.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/infrastructure/repositories/mock_auth_repository.dart";

/// Point d'entrée principal initialisant les dépendances et l'application KinoaPay.
void main() {
  final authRepository = MockAuthRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
      ],
      child: const KinoaPayApp(),
    ),
  );
}

/// Racine de l'application configurant le thème visuel et le système de routage.
class KinoaPayApp extends StatelessWidget {
  const KinoaPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "KinoaPay",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme).apply(
          bodyColor: KinoaColors.stone900,
          displayColor: KinoaColors.stone900,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: KinoaColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            splashFactory: NoSplash.splashFactory,
            overlayColor: Colors.transparent,
          ),
        ),
      ),
      initialRoute: KinoaRouter.welcome,
      onGenerateRoute: KinoaRouter.generateRoute,
    );
  }
}
