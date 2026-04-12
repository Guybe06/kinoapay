import "package:flutter/widgets.dart";

/// Représente un onglet de la navigation principale.
class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
