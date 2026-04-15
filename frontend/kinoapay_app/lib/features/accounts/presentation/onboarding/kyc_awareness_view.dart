import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Écran de sensibilisation au KYC affiché après la création du compte.
/// Propose la vérification immédiate ou différée, les deux mènent au shell pour l'instant.
class KycAwarenessView extends StatelessWidget {
  const KycAwarenessView({super.key});

  void _goNext(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, KinoaRoutes.paymentSetup, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: KinoaColors.quinoaCream,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),
                _buildBadge(),
                const SizedBox(height: 28),
                const Text(
                  AuthStrings.kycTitle,
                  style: TextStyle(
                    color: KinoaColors.quinoaDark,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AuthStrings.kycSubtitle,
                  style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 36),
                _buildBenefit(icon: SolarIconsOutline.sendSquare, text: AuthStrings.kycBenefitTransfer),
                const SizedBox(height: 16),
                _buildBenefit(icon: SolarIconsOutline.layersMinimalistic, text: AuthStrings.kycBenefitMobile),
                const SizedBox(height: 16),
                _buildBenefit(icon: SolarIconsOutline.bolt, text: AuthStrings.kycBenefitSecurity),
                const Spacer(flex: 3),
                KinoaPrimaryButton(text: AuthStrings.kycVerifyNow, onPressed: () => _goNext(context)),
                const SizedBox(height: 12),
                KinoaPrimaryButton(
                  text: AuthStrings.kycLater,
                  isSecondary: true,
                  onPressed: () => _goNext(context),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    AuthStrings.kycLaterNote,
                    style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.35), fontSize: 12),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: KinoaColors.quinoaGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(SolarIconsOutline.userCheck, color: KinoaColors.quinoaGold, size: 16),
          const SizedBox(width: 8),
          const Text(
            "Vérification d'identité",
            style: TextStyle(color: KinoaColors.quinoaGold, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: KinoaColors.quinoaDark.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: KinoaColors.quinoaDark, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
