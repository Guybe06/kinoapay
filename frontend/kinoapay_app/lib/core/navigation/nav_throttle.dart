import "package:flutter/material.dart";

/// Empêche les double-taps sur les boutons de navigation en verrouillant pendant un push.
/// Un pop n'est jamais verrouillé : l'utilisateur doit toujours pouvoir revenir en arrière.
class NavThrottle extends NavigatorObserver {
  static bool _isTransitioning = false;

  /// @return false uniquement pendant les 300ms suivant un push
  static bool get canNavigate => !_isTransitioning;

  @override
  void didPush(Route route, Route? previousRoute) {
    _lock();
  }

  void _lock() {
    _isTransitioning = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      _isTransitioning = false;
    });
  }
}
