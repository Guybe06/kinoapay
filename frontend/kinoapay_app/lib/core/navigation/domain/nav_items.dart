import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";
import "package:kinoapay_app/core/navigation/domain/nav_item.dart";

/// Liste des 3 onglets de la navigation principale.
class NavItems {
  static const List<NavItem> all = [
    NavItem(
      label: AppStrings.navDashboard,
      icon: SolarIconsOutline.home2,
      activeIcon: SolarIconsBold.home2,
    ),
    NavItem(
      label: AppStrings.navTransfer,
      icon: SolarIconsOutline.plain,
      activeIcon: SolarIconsBold.plain,
    ),
    NavItem(
      label: AppStrings.navMore,
      icon: SolarIconsOutline.widget,
      activeIcon: SolarIconsBold.widget,
    ),
  ];
}
