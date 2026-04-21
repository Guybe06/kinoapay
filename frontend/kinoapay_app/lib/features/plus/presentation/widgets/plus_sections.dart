import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/plus/domain/plus_strings.dart";
import "package:kinoapay_app/features/plus/presentation/widgets/plus_widgets.dart";

/// Section « Mon compte » : KYC, sécurité, préférences.
class PlusAccountSection extends StatelessWidget {
  final bool compact;
  const PlusAccountSection({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final kycVerified =
        authState is Authenticated && authState.user.kycVerified;

    return Column(
      children: [
        PlusListCard(
          icon: SolarIconsOutline.userCircle,
          label: PlusStrings.actionProfile,
          description: PlusStrings.descProfile,
          color: AppColors.warning,
          onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        ),
        SizedBox(height: compact ? 6 : 10),
        PlusListCard(
          icon: SolarIconsOutline.shieldCheck,
          label: PlusStrings.actionKyc,
          description: PlusStrings.descKyc,
          color: kycVerified ? AppColors.success : AppColors.quinoaGold,
          trailing: _KycBadge(verified: kycVerified, compact: compact),
          onTap: () => Navigator.pushNamed(context, AppRoutes.kyc),
          compact: compact,
        ),
        SizedBox(height: compact ? 6 : 10),
        PlusListCard(
          icon: SolarIconsOutline.lockPassword,
          label: PlusStrings.actionSecurity,
          description: PlusStrings.descSecurity,
          color: AppColors.quinoaDark,
          onTap: () => Navigator.pushNamed(context, AppRoutes.security),
          compact: compact,
        ),
        SizedBox(height: compact ? 6 : 10),
        PlusListCard(
          icon: SolarIconsOutline.settings,
          label: PlusStrings.actionPreferences,
          description: PlusStrings.descPreferences,
          color: AppColors.textMuted,
          onTap: () => Navigator.pushNamed(context, AppRoutes.preferences),
          compact: compact,
        ),
      ],
    );
  }
}

/// Section « Support » : aide, contact, signalement.
class PlusSupportSection extends StatelessWidget {
  final bool compact;
  const PlusSupportSection({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlusListCard(
          icon: SolarIconsOutline.questionCircle,
          label: PlusStrings.actionHelp,
          description: PlusStrings.descHelp,
          color: AppColors.quinoaGold,
          onTap: () => Navigator.pushNamed(context, AppRoutes.help),
          compact: compact,
        ),
        SizedBox(height: compact ? 6 : 10),
        PlusListCard(
          icon: SolarIconsOutline.chatRound,
          label: PlusStrings.actionContact,
          description: PlusStrings.descContact,
          color: AppColors.pending,
          onTap: () => Navigator.pushNamed(context, AppRoutes.contactSupport),
          compact: compact,
        ),
        SizedBox(height: compact ? 6 : 10),
        PlusListCard(
          icon: SolarIconsOutline.bugMinimalistic,
          label: PlusStrings.actionReport,
          description: PlusStrings.descReport,
          color: AppColors.quinoaRed,
          onTap: () => Navigator.pushNamed(context, AppRoutes.reportIssue),
          compact: compact,
        ),
      ],
    );
  }
}

/// Badge pill indiquant le statut KYC de l'utilisateur.
class _KycBadge extends StatelessWidget {
  final bool verified;
  final bool compact;

  const _KycBadge({required this.verified, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final color = verified ? AppColors.success : AppColors.quinoaGold;
    final label = verified
        ? PlusStrings.kycStatusVerified
        : PlusStrings.kycStatusPending;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: compact ? 9 : 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
