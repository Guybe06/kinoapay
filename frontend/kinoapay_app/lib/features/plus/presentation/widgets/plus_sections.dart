import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/plus/domain/plus_strings.dart";
import "package:kinoapay_app/features/plus/presentation/widgets/plus_widgets.dart";

/// Section « Mon compte » : KYC, sécurité, préférences.
class PlusAccountSection extends StatelessWidget {
  const PlusAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlusListCard(
          icon: SolarIconsOutline.shieldCheck,
          label: PlusStrings.actionKyc,
          description: PlusStrings.descKyc,
          color: AppColors.success,
          onTap: () {},
        ),
        const SizedBox(height: 10),
        PlusListCard(
          icon: SolarIconsOutline.lockPassword,
          label: PlusStrings.actionSecurity,
          description: PlusStrings.descSecurity,
          color: AppColors.quinoaDark,
          onTap: () {},
        ),
        const SizedBox(height: 10),
        PlusListCard(
          icon: SolarIconsOutline.settings,
          label: PlusStrings.actionPreferences,
          description: PlusStrings.descPreferences,
          color: AppColors.textMuted,
          onTap: () {},
        ),
      ],
    );
  }
}

/// Section « Support » : aide, contact, signalement.
class PlusSupportSection extends StatelessWidget {
  const PlusSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlusListCard(
          icon: SolarIconsOutline.questionCircle,
          label: PlusStrings.actionHelp,
          description: PlusStrings.descHelp,
          color: AppColors.quinoaGold,
          onTap: () {},
        ),
        const SizedBox(height: 10),
        PlusListCard(
          icon: SolarIconsOutline.chatRound,
          label: PlusStrings.actionContact,
          description: PlusStrings.descContact,
          color: AppColors.pending,
          onTap: () {},
        ),
        const SizedBox(height: 10),
        PlusListCard(
          icon: SolarIconsOutline.bugMinimalistic,
          label: PlusStrings.actionReport,
          description: PlusStrings.descReport,
          color: AppColors.quinoaRed,
          onTap: () {},
        ),
      ],
    );
  }
}
