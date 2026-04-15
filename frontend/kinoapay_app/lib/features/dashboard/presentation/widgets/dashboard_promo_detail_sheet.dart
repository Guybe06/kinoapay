import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Bottom sheet « En savoir plus » : texte marketing structuré.
class DashboardPromoDetailSheet extends StatelessWidget {
  const DashboardPromoDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141414),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                      children: [
                        const Text(
                          "Transférez partout,\nsans friction",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.link,
                          title: "Le lien entre tous vos comptes",
                          description:
                              "kinoaPay fait le pont entre vos comptes Mobile Money et vos banques. Vous n'avez pas besoin de créer un nouveau compte ou d'y stocker de l'argent : nous faisons simplement en sorte que vos comptes se parlent enfin.",
                        ),
                        const SizedBox(height: 32),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.userId,
                          title: "Une identité unique pour tout recevoir",
                          description:
                              "Avec votre KinoaID, recevoir de l'argent devient un jeu d'enfant. Ne donnez plus vos numéros de téléphone ou vos coordonnées bancaires à tout le monde. Un seul identifiant suffit pour recevoir vos fonds directement là où vous le souhaitez.",
                        ),
                        const SizedBox(height: 32),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.safeCircle,
                          title: "Un reçu numérique qui ne ment jamais",
                          description:
                              "Chaque transaction est protégée par une preuve numérique infalsifiable. C'est une garantie que personne ne peut contester : votre argent est suivi à la trace et arrive toujours à bon port, avec une transparence totale.",
                        ),
                        const SizedBox(height: 32),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.bolt,
                          title: "L'intelligence qui évite les attentes",
                          description:
                              "Notre système surveille la santé des réseaux en temps réel. Si un opérateur ralentit ou tombe en panne, kinoaPay le voit instantanément et trouve automatiquement un chemin plus rapide pour que votre transfert reste immédiat.",
                        ),
                        const SizedBox(height: 48),
                        Text(
                          "kinoaPay ne change pas vos habitudes, il les simplifie en connectant vos moyens de paiement préférés sous une protection universelle.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Bloc titre + paragraphe dans la feuille promo.
class DashboardPromoInfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const DashboardPromoInfoSection({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.accent, size: 28),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
