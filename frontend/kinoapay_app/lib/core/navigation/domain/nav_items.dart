import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";
import "package:kinoapay_app/core/navigation/domain/nav_item.dart";

/// Liste des onglets de la navigation principale avec les icônes Solar.
class NavItems {
  static const List<NavItem> all = [
    NavItem(
      label: KinoaStrings.navDashboard,
      icon: SolarIconsOutline.home2,
      activeIcon: SolarIconsBold.home2,
    ),
    NavItem(
      label: KinoaStrings.navTransfer,
      icon: SolarIconsOutline.sendSquare,
      activeIcon: SolarIconsBold.sendSquare,
    ),
    NavItem(
      label: KinoaStrings.navHistory,
      icon: SolarIconsOutline.history,
      activeIcon: SolarIconsBold.history,
    ),
    NavItem(
      label: KinoaStrings.navProfile,
      icon: SolarIconsOutline.user,
      activeIcon: SolarIconsBold.user,
    ),
  ];
}
