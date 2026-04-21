import "package:flutter/material.dart";

/// Factories de transitions réutilisables pour [AppRouter.generateRoute].
abstract final class RouteTransitions {
  /// Fondu court, réservé au splash.
  static PageRouteBuilder fade(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Fondu long, laisse le Hero s'animer librement.
  static PageRouteBuilder hero(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  /// Slide horizontal droite + scale + fade entrant uniquement.
  /// Page entrante : slide de droite, scale 0.95->1.0, fade 0.0->1.0 sur les 40% initiaux.
  /// Page sortante : poussée à gauche, légèrement réduite, reste opaque.
  static PageRouteBuilder slide(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final curvedSecondary = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic);

        final slideIn = Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero)
            .animate(curved);
        final slideOut = Tween<Offset>(begin: Offset.zero, end: const Offset(-0.25, 0))
            .animate(curvedSecondary);
        final scaleIn = Tween<double>(begin: 0.95, end: 1.0).animate(curved);
        final scaleOut = Tween<double>(begin: 1.0, end: 0.95).animate(curvedSecondary);
        final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
          ),
        );

        return SlideTransition(
          position: slideOut,
          child: ScaleTransition(
            scale: scaleOut,
            child: SlideTransition(
              position: slideIn,
              child: ScaleTransition(
                scale: scaleIn,
                child: FadeTransition(opacity: fadeIn, child: child),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Transition inter-étapes auth : slide droite→centre + fade entrant.
  /// Pas de secondary animation pour éviter la corruption du layer tree.
  static PageRouteBuilder authStep(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, secondary, child) {
        final slide = Tween<Offset>(
          begin: const Offset(0.20, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

        final fade = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        );

        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: fade, child: child),
        );
      },
    );
  }

  /// Scale-up avec fondu, réservé aux écrans de célébration / succès.
  static PageRouteBuilder scaleUp(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, a, b) => page,
      transitionsBuilder: (_, animation, b, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
