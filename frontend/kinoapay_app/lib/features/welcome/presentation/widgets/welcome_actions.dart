import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";
import "package:kinoapay_app/core/navigation/kinoa_router.dart";

/// Affiche les boutons d'appel à l'action adaptés pour un fond clair.
class WelcomeActions extends StatelessWidget {
  const WelcomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _WelcomeButton(
            text: KinoaStrings.welcomeSignupBtn,
            isPrimary: true,
            onPressed: () {
              Navigator.pushNamed(context, KinoaRouter.signup);
            },
          ),
          const SizedBox(height: 10),
          _WelcomeButton(
            text: KinoaStrings.welcomeSigninBtn,
            isPrimary: false,
            onPressed: () {
              Navigator.pushNamed(context, KinoaRouter.signin);
            },
          ),
        ],
      ),
    );
  }
}

class _WelcomeButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _WelcomeButton({
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? KinoaColors.primary : Colors.white,
          foregroundColor: isPrimary ? Colors.white : KinoaColors.primary,
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
          shape: const StadiumBorder(
            side: BorderSide(color: KinoaColors.primary, width: 1.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (isPrimary) ...[
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
