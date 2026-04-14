import "package:flutter/material.dart";

/// Empêche les navigations concurrentes (double-tap) en bloquant les push pendant une transition.
class KinoaNavThrottle extends NavigatorObserver {
  static bool _isTransitioning = false;

  /// Vérifie si une navigation est possible (pas de transition en cours).
  static bool get canNavigate => !_isTransitioning;

  @override
  void didPush(Route route, Route? previousRoute) {
    _lock();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _lock();
  }

  void _lock() {
    _isTransitioning = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      _isTransitioning = false;
    });
  }
}
