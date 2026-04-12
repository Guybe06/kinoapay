import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";

/// En-tête persistant du shell — fond sombre, logo quinoa, raccourcis QR / contacts / notifs.
class KinoaHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool withHero;
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
    final topInset = MediaQuery.of(context).padding.top;

    return Container(
      // Fond translucide pour que le contenu défilant passe dessous proprement
      color: KinoaColors.stone950.withValues(alpha: 0.95),
      padding: EdgeInsets.fromLTRB(20, topInset + 10, 16, 10),
      height: preferredSize.height + topInset,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(),
          const Spacer(),
          _HeaderIconBtn(
            icon: SolarIconsOutline.usersGroupTwoRounded,
            tooltip: KinoaStrings.headerContacts,
            onTap: () => Navigator.pushNamed(context, KinoaRoutes.contacts),
          ),
          const SizedBox(width: 6),
          _NotificationBtn(
            unreadCount: unreadNotifications,
            onTap: () => Navigator.pushNamed(context, KinoaRoutes.notifications),
          ),
          const SizedBox(width: 6),
          _HeaderIconBtn(
            icon: SolarIconsOutline.qrCode,
            tooltip: KinoaStrings.headerScan,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    const brand = KinoaBrand(
      size: BrandSize.sm,
      color: Colors.white,
      iconColor: KinoaColors.quinoaGold,
    );
    if (withHero) return const Hero(tag: "kinoa_brand", child: brand);
    return brand;
  }
}

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _HeaderIconBtn({
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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Icon(icon, size: 19, color: KinoaColors.stone300),
        ),
      ),
    );
  }
}

class _NotificationBtn extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationBtn({required this.unreadCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: KinoaStrings.headerNotifications,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                unreadCount > 0 ? SolarIconsBold.bell : SolarIconsOutline.bell,
                size: 19,
                color: KinoaColors.stone300,
              ),
              if (unreadCount > 0)
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      // quinoaRed : signal d'alerte discret, pas agressif
                      color: KinoaColors.quinoaRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
