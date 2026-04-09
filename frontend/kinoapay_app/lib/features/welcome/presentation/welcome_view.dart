import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";
import "package:kinoapay_app/core/navigation/kinoa_router.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";

/// Une page d'accueil immersive inspirée du design "Burt" avec cards imbriquées.
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan dégradé pastel
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE2D1F9), // Violet pastel
                    Color(0xFFFEE1C7), // Orange pastel
                    Color(0xFFD1F2F9), // Cyan pastel
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header avec Logo Kinoa
                  const KinoaBrand(
                    size: BrandSize.lg,
                    color: KinoaColors.stone900,
                    iconColor: KinoaColors.stone900,
                    alignment: MainAxisAlignment.start,
                  ),
                  const SizedBox(height: 56),
                  
                  // Titre et Sous-titre
                  const Text(
                    KinoaStrings.welcomeHeroTitle,
                    style: TextStyle(
                      color: KinoaColors.stone900,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    KinoaStrings.welcomeHeroSubtitle,
                    style: TextStyle(
                      color: KinoaColors.stone900.withValues(alpha: 0.7),
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Illustration par Cards imbriquées (Utilisation des nouvelles images welcome-2 et welcome-3)
                  Center(
                    child: SizedBox(
                      height: 260,
                      width: 280,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Card Centrale (Fond) - Image principale
                          Align(
                            alignment: Alignment.center,
                            child: _PromoCard(
                              width: 200,
                              height: 160,
                              image: "assets/images/welcome.jpg",
                              elevation: 6,
                            ),
                          ),
                          // Card Petite 1 (Top Gauche) - Nouvelle image 2
                          Positioned(
                            left: 0,
                            top: 10,
                            child: _PromoCard(
                              width: 100,
                              height: 120,
                              image: "assets/images/welcome-2.jpg",
                              elevation: 15,
                            ),
                          ),
                          // Card Petite 2 (Bottom Droite) - Nouvelle image 3
                          Positioned(
                            right: 0,
                            bottom: 10,
                            child: _PromoCard(
                              width: 110,
                              height: 90,
                              image: "assets/images/welcome-3.jpg",
                              elevation: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Action Button (Étendu sur toute la largeur)
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, KinoaRouter.signup),
                    child: Container(
                      width: double.infinity,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: KinoaColors.stone900,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.zero,
                          bottomLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        KinoaStrings.welcomeSignupBtn,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Lien Se connecter
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, KinoaRouter.signin),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text.rich(
                        TextSpan(
                          text: "${KinoaStrings.signupHaveAccount} ",
                          style: TextStyle(
                            color: KinoaColors.stone900.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                          children: const [
                            TextSpan(
                              text: KinoaStrings.signupSigninLink,
                              style: TextStyle(color: KinoaColors.stone900, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final double width;
  final double height;
  final String image;
  final double elevation;

  const _PromoCard({
    required this.width,
    required this.height,
    required this.image,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topLeft: Radius.zero, // Coin supérieur gauche carré
      topRight: Radius.circular(24),
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
