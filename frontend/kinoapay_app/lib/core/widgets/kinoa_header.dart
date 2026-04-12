import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";

/// En-tête persistant du shell : logo KinoaPay + raccourcis QR, contacts, notifications.
class KinoaHeader extends StatelessWidget implements PreferredSizeWidget {
  /// true si le logo doit s'animer en Hero depuis le splash.
  final bool withHero;

  /// Nombre de notifications non lues, affiche un badge si > 0.
  final int unreadNotifications;

  const KinoaHeader({
    super.key,
    this.withHero = false,
    this.unreadNotifications = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: KinoaColors.navBackground,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: preferredSize.height,
      child: Row(
        children: [
          _buildLogo(),
          const Spacer(),
          _HeaderIconButton(
            icon: Icons.qr_code_scanner_rounded,
            tooltip: KinoaStrings.headerScan,
            onTap: () => Navigator.pushNamed(context, KinoaRoutes.contacts),
          ),
          const SizedBox(width: 4),
          _HeaderIconButton(
            icon: Icons.people_outline_rounded,
            tooltip: KinoaStrings.headerContacts,
            onTap: () => Navigator.pushNamed(context, KinoaRoutes.contacts),
          ),
          const SizedBox(width: 4),
          _NotificationButton(
            unreadCount: unreadNotifications,
            onTap: () => Navigator.pushNamed(context, KinoaRoutes.notifications),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    const brand = KinoaBrand(size: BrandSize.sm, color: KinoaColors.textLight);
    if (withHero) return const Hero(tag: "kinoa_brand", child: brand);
    return brand;
  }
}

/// Bouton icône standard du header avec tooltip.
class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 22, color: KinoaColors.navInactive),
        ),
      ),
    );
  }
}

/// Bouton notification avec badge du nombre de messages non lus.
class _NotificationButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationButton({
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: KinoaStrings.headerNotifications,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: 22,
                color: KinoaColors.navInactive,
              ),
              if (unreadCount > 0) _buildBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Positioned(
      top: -4,
      right: -4,
      child: Container(
        width: 16,
        height: 16,
        decoration: const BoxDecoration(
          color: KinoaColors.error,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          unreadCount > 9 ? "9+" : "$unreadCount",
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: KinoaColors.textLight,
          ),
        ),
      ),
    );
  }
}
