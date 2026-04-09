import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/navigation/kinoa_router.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";

/// Point d'entrée principal de l'application après authentification réussie.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  /// Construit l'interface utilisateur de l'écran d'accueil.
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushReplacementNamed(context, KinoaRouter.welcome);
        }
      },
      child: Scaffold(
        backgroundColor: KinoaColors.background,
        appBar: AppBar(
          title: const Text("KinoaPay", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => context.read<AuthBloc>().add(SignOutRequested()),
            ),
          ],
        ),
        body: const Center(
          child: Text(
            "Bienvenue sur votre espace sécurisé",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
