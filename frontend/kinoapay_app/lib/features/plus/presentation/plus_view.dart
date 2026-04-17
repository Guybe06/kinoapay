import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_header.dart";
import "package:kinoapay_app/features/plus/domain/plus_strings.dart";

/// Vue principale de la feature Plus.
/// Design typographique avec des titres massifs et des cartes épurées.
class PlusView extends StatelessWidget {
  final int unreadNotifications;
  const PlusView({super.key, this.unreadNotifications = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      appBar: AppHeader(unreadNotifications: unreadNotifications),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              PlusStrings.title,
              style: TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              PlusStrings.subtitle,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _PlusActionCard(
                  icon: SolarIconsOutline.scanner,
                  label: PlusStrings.actionScan,
                  description: PlusStrings.descScan,
                  color: AppColors.quinoaDark,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.scanner),
                ),
                _PlusActionCard(
                  icon: SolarIconsOutline.cardReceive,
                  label: PlusStrings.actionRequest,
                  description: PlusStrings.descRequest,
                  color: AppColors.pending,
                  onTap: () {}, // TODO: Implémenter la vue de demande
                ),
                _PlusActionCard(
                  icon: SolarIconsOutline.history,
                  label: PlusStrings.actionHistory,
                  description: PlusStrings.descHistory,
                  color: AppColors.quinoaGold,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.history),
                ),
                _PlusActionCard(
                  icon: SolarIconsOutline.card2,
                  label: PlusStrings.actionChannels,
                  description: PlusStrings.descChannels,
                  color: AppColors.success,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.channels),
                ),
                _PlusActionCard(
                  icon: SolarIconsOutline.usersGroupTwoRounded,
                  label: PlusStrings.actionContacts,
                  description: PlusStrings.descContacts,
                  color: AppColors.quinoaDark,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.contacts),
                ),
                _PlusActionCard(
                  icon: SolarIconsOutline.userCircle,
                  label: PlusStrings.actionProfile,
                  description: PlusStrings.descProfile,
                  color: AppColors.warning,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlusActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _PlusActionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.quinoaDark.withValues(alpha: 0.03),
              blurRadius: 40,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 36),
                Icon(
                  SolarIconsOutline.arrowRightUp,
                  color: AppColors.quinoaDark.withValues(alpha: 0.1),
                  size: 24,
                ),
              ],
            ),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
