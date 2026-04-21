import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/domain/kyc_strings.dart";

/// Protège l'accès à une feature derrière la vérification KYC.
///
/// Affiche [child] si [kycVerified] est `true`, sinon une page bloquante
/// avec un CTA vers le profil pour initier la vérification.
class KycGate extends StatelessWidget {
  final bool kycVerified;
  final Widget child;
  final VoidCallback onClose;

  const KycGate({
    super.key,
    required this.kycVerified,
    required this.child,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (kycVerified) return child;
    return _KycBlockedScreen(onClose: onClose);
  }
}

class _KycBlockedScreen extends StatelessWidget {
  final VoidCallback onClose;

  const _KycBlockedScreen({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.quinoaGold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  SolarIconsOutline.shieldCheck,
                  size: 32,
                  color: AppColors.quinoaGold,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                KycStrings.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                KycStrings.body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.kyc),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.quinoaDark,
                    foregroundColor: AppColors.quinoaCream,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    KycStrings.cta,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onClose,
                child: Text(
                  KycStrings.back,
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.45),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
