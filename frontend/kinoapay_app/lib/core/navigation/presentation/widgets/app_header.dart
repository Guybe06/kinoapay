import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";

/// En-tête minimaliste : logo à gauche, cloche ronde avec badge de notifs à droite.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool withHero;
  final int unreadNotifications;

  const AppHeader({
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
      color: AppColors.quinoaCream,
      padding: EdgeInsets.fromLTRB(20, topInset + 10, 20, 10),
      height: preferredSize.height + topInset,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(),
          const Spacer(),
          _NotificationBtn(
            unreadCount: unreadNotifications,
            onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    const brand = BrandLogoRow(
      size: BrandSize.sm,
      color: AppColors.quinoaDark,
      iconColor: AppColors.quinoaGold,
    );
    if (withHero) return const Hero(tag: "kinoa_brand", child: brand);
    return brand;
  }
}

class _NotificationBtn extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationBtn({required this.unreadCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;
    final label = unreadCount > 99 ? "99+" : "$unreadCount";

    return Tooltip(
      message: AppStrings.headerNotifications,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  SolarIconsOutline.bell,
                  size: 28,
                  color: AppColors.quinoaGold,
                ),
              ),
            ),
            if (hasUnread)
              Positioned(
                top: -4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.quinoaCream, width: 3),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.quinoaDark,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
