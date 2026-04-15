import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/onboarding/domain/onboarding_strings.dart";
import "package:kinoapay_app/features/onboarding/presentation/celebration/celebration_painter.dart";

/// Écran de célébration post-inscription avec animation staggerée.
class CelebrationView extends StatefulWidget {
  const CelebrationView({super.key});

  @override
  State<CelebrationView> createState() => _CelebrationViewState();
}

class _CelebrationViewState extends State<CelebrationView> with TickerProviderStateMixin {
  late final AnimationController _ctrl;

  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _checkScale;
  late final Animation<double> _ring1Scale;
  late final Animation<double> _ring1Opacity;
  late final Animation<double> _ring2Scale;
  late final Animation<double> _ring2Opacity;
  late final Animation<double> _particles;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _bodyFade;
  late final Animation<double> _btnFade;
  late final Animation<Offset> _btnSlide;

  String get _firstName {
    final args = ModalRoute.of(context)?.settings.arguments;
    return args is String && args.isNotEmpty ? args : "vous";
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

    Animation<double> interval(double begin, double end, Curve curve) =>
        CurvedAnimation(parent: _ctrl, curve: Interval(begin, end, curve: curve));

    _logoFade = interval(0.0, 0.25, Curves.easeOut);
    _logoSlide = Tween(begin: const Offset(0, -0.4), end: Offset.zero).animate(interval(0.0, 0.25, Curves.easeOutCubic));

    _checkScale = Tween<double>(begin: 0.0, end: 1.0).animate(interval(0.18, 0.55, Curves.easeOutBack));

    _ring1Scale = Tween<double>(begin: 1.0, end: 2.4).animate(interval(0.38, 0.68, Curves.easeOut));
    _ring1Opacity = Tween<double>(begin: 0.45, end: 0.0).animate(interval(0.38, 0.68, Curves.easeIn));
    _ring2Scale = Tween<double>(begin: 1.0, end: 3.0).animate(interval(0.48, 0.78, Curves.easeOut));
    _ring2Opacity = Tween<double>(begin: 0.22, end: 0.0).animate(interval(0.48, 0.78, Curves.easeIn));

    _particles = interval(0.32, 0.72, Curves.easeOut);

    _titleFade = interval(0.50, 0.76, Curves.easeOut);
    _titleSlide = Tween(begin: const Offset(0, 0.12), end: Offset.zero).animate(interval(0.50, 0.76, Curves.easeOutCubic));
    _bodyFade = interval(0.62, 0.84, Curves.easeOut);

    _btnFade = interval(0.74, 0.96, Curves.easeOut);
    _btnSlide = Tween(begin: const Offset(0, 0.18), end: Offset.zero).animate(interval(0.74, 0.96, Curves.easeOutCubic));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.quinoaCream,
        body: SafeArea(
          child: Column(
            children: [
              _buildLogoHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return FadeTransition(
      opacity: _logoFade,
      child: SlideTransition(
        position: _logoSlide,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: BrandLogoRow(size: BrandSize.sm, color: AppColors.quinoaDark, iconColor: AppColors.quinoaGold),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(flex: 2),
          _buildCheckAnimation(),
          const SizedBox(height: 48),
          SlideTransition(
            position: _titleSlide,
            child: FadeTransition(
              opacity: _titleFade,
              child: Text(
                "${OnboardingStrings.celebrationSubtitlePrefix} $_firstName !",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: -1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          FadeTransition(
            opacity: _bodyFade,
            child: Text(
              OnboardingStrings.celebrationBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.5),
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ),
          const Spacer(flex: 3),
          SlideTransition(
            position: _btnSlide,
            child: FadeTransition(
              opacity: _btnFade,
              child: PrimaryButton(
                text: OnboardingStrings.celebrationContinue,
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.paymentSetup),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildCheckAnimation() {
    return SizedBox(
      width: 160,
      height: 160,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) => CustomPaint(
          painter: CelebrationPainter(
            checkScale: _checkScale.value,
            ring1Scale: _ring1Scale.value,
            ring1Opacity: _ring1Opacity.value,
            ring2Scale: _ring2Scale.value,
            ring2Opacity: _ring2Opacity.value,
            particleProgress: _particles.value,
          ),
        ),
      ),
    );
  }
}
