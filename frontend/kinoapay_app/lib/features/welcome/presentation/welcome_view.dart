import "dart:ui";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/welcome/domain/welcome_strings.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";
import "package:kinoapay_app/features/welcome/presentation/welcome_entrance_animation.dart";
import "package:kinoapay_app/features/welcome/presentation/widgets/welcome_illustration.dart";

/// Page d'accueil immersive avec animations d'entrée en cascade depuis le splash.
class WelcomeView extends StatefulWidget {
  final bool fromSplash;

  /// @param fromSplash  true si la navigation provient du splash (active le Hero du logo)
  const WelcomeView({super.key, this.fromSplash = false});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final WelcomeEntranceAnimation _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 1100), vsync: this);
    _anim = WelcomeEntranceAnimation(_ctrl);
    Future.delayed(const Duration(milliseconds: 280), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Applique un fade + glissement vertical à [child] selon [opacity].
  /// @param opacity  Animation d'opacité (0→1) pilotant aussi le slide
  /// @param slide    Amplitude du glissement en pixels
  Widget _animated(Animation<double> opacity, Widget child, {double slide = 28}) {
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: KinoaColors.quinoaDeep,
        body: Stack(
          children: [
            _buildGlow(),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 44),
                  _animated(_anim.title, _buildTitle()),
                  const SizedBox(height: 16),
                  _animated(_anim.subtitle, _buildSubtitle()),
                  const Spacer(),
                  _buildImages(),
                  const Spacer(),
                  _animated(_anim.button, _buildActions(context), slide: 40),
                  const SizedBox(height: 16),
                  _animated(_anim.link, _buildSigninLink(context), slide: 20),
                  const SizedBox(height: 12),
                  _animated(_anim.link, _buildTrustLabel(), slide: 10),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustLabel() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.checkmark_shield_fill, color: KinoaColors.quinoaGold, size: 14),
          const SizedBox(width: 8),
          Text(
            WelcomeStrings.trustLabel,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlow() {
    return Positioned(
      top: -80,
      right: -80,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: KinoaColors.quinoaGold.withValues(alpha: 0.15),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
      child: KinoaBrand(
        size: BrandSize.lg,
        color: KinoaColors.white,
        iconColor: KinoaColors.quinoaGold,
        alignment: MainAxisAlignment.start,
        heroTag: widget.fromSplash ? "kinoa_brand" : null,
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Text(
        WelcomeStrings.heroTitle,
        style: const TextStyle(
          color: KinoaColors.white,
          fontSize: 48,
          fontWeight: FontWeight.w900,
          height: 1.0,
          letterSpacing: -2.5,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Text(
        WelcomeStrings.heroSubtitle,
        style: TextStyle(
          color: KinoaColors.white.withValues(alpha: 0.6),
          fontSize: 15,
          height: 1.5,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildImages() {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _anim.images.value.clamp(0.0, 1.0),
        child: Transform.scale(scale: _anim.imagesScale.value, child: child),
      ),
      child: const WelcomeIllustration(),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, KinoaRoutes.signup),
        child: Container(
          width: double.infinity,
          height: 68,
          decoration: BoxDecoration(
            color: KinoaColors.quinoaGold,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                WelcomeStrings.signupBtn,
                style: const TextStyle(
                  color: KinoaColors.quinoaDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(CupertinoIcons.arrow_right, color: KinoaColors.quinoaDark, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSigninLink(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, KinoaRoutes.signin),
        child: Text.rich(
          TextSpan(
            text: "${AuthStrings.signupHaveAccount} ",
            style: TextStyle(
              color: KinoaColors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            children: const [
              TextSpan(
                text: AuthStrings.signupSigninLink,
                style: TextStyle(color: KinoaColors.white, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
