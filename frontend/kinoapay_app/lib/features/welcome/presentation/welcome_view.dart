import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/features/welcome/presentation/welcome_entrance_animation.dart";
import "package:kinoapay_app/features/welcome/presentation/welcome_page_widgets.dart";
import "package:kinoapay_app/core/navigation/route_observer.dart";

/// Page d'accueil immersive avec animations d'entrée en cascade depuis le splash.
class WelcomeView extends StatefulWidget {
  final bool fromSplash;

  /// @param fromSplash  true si la navigation provient du splash (active le Hero du logo)
  const WelcomeView({super.key, this.fromSplash = false});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with SingleTickerProviderStateMixin, RouteAware {
  late final AnimationController _ctrl;
  late final WelcomeEntranceAnimation _anim;
  bool _navigating = false;

  void _navigateTo(String route) {
    if (_navigating) return;
    _navigating = true;
    Navigator.pushNamed(context, route).then((_) => _navigating = false);
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
    _anim = WelcomeEntranceAnimation(_ctrl);
    Future.delayed(const Duration(milliseconds: 280), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is ModalRoute<void>) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    _ctrl.reset();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _ctrl.dispose();
    super.dispose();
  }

  /// Applique un fade + glissement vertical à [child] selon [opacity].
  /// @param opacity  Animation d'opacité (0→1) pilotant aussi le slide
  /// @param slide    Amplitude du glissement en pixels
  Widget _animated(
    Animation<double> opacity,
    Widget child, {
    double slide = 28,
  }) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, c) => Opacity(
        opacity: opacity.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, slide * (1 - opacity.value)),
          child: c,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = ScreenSizeHelper.isSmallOrLess(context);
    final category = ScreenSizeHelper.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.quinoaDeep,
        body: Stack(
          children: [
            const WelcomeBackdropGlow(),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeBrandHeader(
                    heroTag: widget.fromSplash ? "app_brand" : null,
                    compact: compact,
                  ),
                  SizedBox(
                    height: ScreenSizeHelper.adaptiveValue(
                      context,
                      compact: 12,
                      small: 20,
                      medium: 32,
                      large: 44,
                    ),
                  ),
                  _animated(_anim.title, WelcomeHeroTitle(compact: compact)),
                  SizedBox(
                    height: ScreenSizeHelper.adaptiveValue(
                      context,
                      compact: 6,
                      small: 10,
                      medium: 14,
                      large: 16,
                    ),
                  ),
                  _animated(_anim.subtitle, const WelcomeHeroSubtitle()),
                  const Spacer(),
                  WelcomeIllustrationAnimated(
                    opacity: _anim.images,
                    scale: _anim.imagesScale,
                    listenable: _ctrl,
                    compact: compact,
                  ),
                  const Spacer(),
                  _animated(
                    _anim.button,
                    WelcomeSignupCta(
                      onTap: () => _navigateTo(AppRoutes.signup),
                      compact: compact,
                    ),
                    slide: 40,
                  ),
                  SizedBox(
                    height: ScreenSizeHelper.adaptiveValue(
                      context,
                      compact: 6,
                      small: 10,
                      medium: 14,
                      large: 16,
                    ),
                  ),
                  _animated(
                    _anim.link,
                    WelcomeSigninLink(
                      onPressed: () => _navigateTo(AppRoutes.signin),
                    ),
                    slide: 20,
                  ),
                  if (category == ScreenSizeCategory.medium ||
                      category == ScreenSizeCategory.large) ...[
                    SizedBox(
                      height: ScreenSizeHelper.adaptiveValue(
                        context,
                        compact: 0,
                        small: 0,
                        medium: 10,
                        large: 12,
                      ),
                    ),
                    _animated(_anim.link, const WelcomeTrustLabel(), slide: 10),
                  ],
                  SizedBox(
                    height: ScreenSizeHelper.adaptiveValue(
                      context,
                      compact: 8,
                      small: 10,
                      medium: 20,
                      large: 28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
