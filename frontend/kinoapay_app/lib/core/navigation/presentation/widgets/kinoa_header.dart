import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";

/// En-tête light — fond quinoaCream, logo quinoaDark/quinoaGold, icônes colorées.
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
      color: KinoaColors.quinoaCream,
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
            color: KinoaColors.quinoaDark,
            onTap: () => Navigator.pushNamed(context, KinoaRoutes.contacts),
          ),
          const SizedBox(width: 6),
          _NotificationBtn(
            unreadCount: unreadNotifications,
            color: KinoaColors.quinoaDark,
            onTap: () => Navigator.pushNamed(context, KinoaRoutes.notifications),
          ),
          const SizedBox(width: 6),
          _HeaderIconBtn(
            icon: SolarIconsOutline.qrCode,
            tooltip: KinoaStrings.headerScan,
            color: KinoaColors.accent,
            iconColor: KinoaColors.quinoaDark,
            solidBg: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    const brand = KinoaBrand(
      size: BrandSize.sm,
      color: KinoaColors.quinoaDark,
      iconColor: KinoaColors.quinoaGold,
    );
    if (withHero) return const Hero(tag: "kinoa_brand", child: brand);
    return brand;
  }
}

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final Color? iconColor;
  final bool solidBg;
  final VoidCallback onTap;

  const _HeaderIconBtn({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
    this.iconColor,
    this.solidBg = false,
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
            color: solidBg ? color : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: solidBg ? null : Border.all(color: color.withValues(alpha: 0.12)),
          ),
          child: Icon(icon, size: 19, color: iconColor ?? color),
        ),
      ),
    );
  }
}

class _NotificationBtn extends StatelessWidget {
  final int unreadCount;
  final Color color;
  final VoidCallback onTap;

  const _NotificationBtn({
    required this.unreadCount,
    required this.color,
    required this.onTap,
  });

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
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.12)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                unreadCount > 0 ? SolarIconsBold.bell : SolarIconsOutline.bell,
                size: 19,
                color: color,
              ),
              if (unreadCount > 0)
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: color,
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
