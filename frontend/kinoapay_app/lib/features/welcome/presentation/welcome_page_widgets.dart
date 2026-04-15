import "dart:ui";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";
import "package:kinoapay_app/features/welcome/domain/welcome_strings.dart";
import "package:kinoapay_app/features/welcome/presentation/widgets/welcome_illustration.dart";

/// Halo doré flouté en haut à droite.
class WelcomeBackdropGlow extends StatelessWidget {
  const WelcomeBackdropGlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -80,
      right: -80,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.quinoaGold.withValues(alpha: 0.15),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/// Logo en-tête ; [heroTag] non null pour la transition depuis le splash.
class WelcomeBrandHeader extends StatelessWidget {
  final String? heroTag;

  const WelcomeBrandHeader({super.key, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
      child: BrandLogoRow(
        size: BrandSize.lg,
        color: AppColors.white,
        iconColor: AppColors.quinoaGold,
        alignment: MainAxisAlignment.start,
        heroTag: heroTag,
      ),
    );
  }
}

/// Titre principal du hero (animation séparée du sous-titre).
class WelcomeHeroTitle extends StatelessWidget {
  const WelcomeHeroTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Text(
        WelcomeStrings.heroTitle,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 48,
          fontWeight: FontWeight.w900,
          height: 1.0,
          letterSpacing: -2.5,
        ),
      ),
    );
  }
}

/// Sous-titre du hero.
class WelcomeHeroSubtitle extends StatelessWidget {
  const WelcomeHeroSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Text(
        WelcomeStrings.heroSubtitle,
        style: TextStyle(
          color: AppColors.white.withValues(alpha: 0.6),
          fontSize: 15,
          height: 1.5,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

/// Illustration avec opacité / scale pilotés de l’extérieur.
class WelcomeIllustrationAnimated extends StatelessWidget {
  final Animation<double> opacity;
  final Animation<double> scale;
  final Listenable listenable;

  const WelcomeIllustrationAnimated({
    super.key,
    required this.opacity,
    required this.scale,
    required this.listenable,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: listenable,
      builder: (_, child) => Opacity(
        opacity: opacity.value.clamp(0.0, 1.0),
        child: Transform.scale(scale: scale.value, child: child),
      ),
      child: const WelcomeIllustration(),
    );
  }
}

/// Bouton principal « Créer un compte ».
class WelcomeSignupCta extends StatelessWidget {
  final VoidCallback onTap;

  const WelcomeSignupCta({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.quinoaGold,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                WelcomeStrings.signupBtn,
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(CupertinoIcons.arrow_right, color: AppColors.quinoaDark, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lien « Déjà un compte ? Connexion ».
class WelcomeSigninLink extends StatelessWidget {
  final VoidCallback onPressed;

  const WelcomeSigninLink({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: Text.rich(
          TextSpan(
            text: "${AuthStrings.signupHaveAccount} ",
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            children: const [
              TextSpan(
                text: AuthStrings.signupSigninLink,
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ligne « Sécurisé · … » sous le lien connexion.
class WelcomeTrustLabel extends StatelessWidget {
  const WelcomeTrustLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.checkmark_shield_fill, color: AppColors.quinoaGold, size: 14),
          const SizedBox(width: 8),
          Text(
            WelcomeStrings.trustLabel,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
