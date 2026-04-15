import "dart:math" as math;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Écran de célébration post-inscription avec animation staggerée.
class CelebrationView extends StatefulWidget {
  const CelebrationView({super.key});

  @override
  State<CelebrationView> createState() => _CelebrationViewState();
}

class _CelebrationViewState extends State<CelebrationView> with TickerProviderStateMixin {
  late final AnimationController _ctrl;

  // Logo
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  // Checkmark
  late final Animation<double> _checkScale;
  // Rings
  late final Animation<double> _ring1Scale;
  late final Animation<double> _ring1Opacity;
  late final Animation<double> _ring2Scale;
  late final Animation<double> _ring2Opacity;
  // Particules
  late final Animation<double> _particles;
  // Texte
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _bodyFade;
  // Bouton
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

    _logoFade   = interval(0.0, 0.25, Curves.easeOut);
    _logoSlide  = Tween(begin: const Offset(0, -0.4), end: Offset.zero)
        .animate(interval(0.0, 0.25, Curves.easeOutCubic));

    _checkScale = Tween<double>(begin: 0.0, end: 1.0)
        .animate(interval(0.18, 0.55, Curves.easeOutBack));

    _ring1Scale   = Tween<double>(begin: 1.0, end: 2.4)
        .animate(interval(0.38, 0.68, Curves.easeOut));
    _ring1Opacity = Tween<double>(begin: 0.45, end: 0.0)
        .animate(interval(0.38, 0.68, Curves.easeIn));
    _ring2Scale   = Tween<double>(begin: 1.0, end: 3.0)
        .animate(interval(0.48, 0.78, Curves.easeOut));
    _ring2Opacity = Tween<double>(begin: 0.22, end: 0.0)
        .animate(interval(0.48, 0.78, Curves.easeIn));

    _particles  = interval(0.32, 0.72, Curves.easeOut);

    _titleFade  = interval(0.50, 0.76, Curves.easeOut);
    _titleSlide = Tween(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(interval(0.50, 0.76, Curves.easeOutCubic));
    _bodyFade   = interval(0.62, 0.84, Curves.easeOut);

    _btnFade    = interval(0.74, 0.96, Curves.easeOut);
    _btnSlide   = Tween(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(interval(0.74, 0.96, Curves.easeOutCubic));

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: const Align(
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
                "${AuthStrings.celebrationSubtitlePrefix} $_firstName !",
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
              AuthStrings.celebrationBody,
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
                text: "Continuer",
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.kycAwareness),
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
          painter: _CelebrationPainter(
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

class _CelebrationPainter extends CustomPainter {
  final double checkScale;
  final double ring1Scale;
  final double ring1Opacity;
  final double ring2Scale;
  final double ring2Opacity;
  final double particleProgress;

  const _CelebrationPainter({
    required this.checkScale,
    required this.ring1Scale,
    required this.ring1Opacity,
    required this.ring2Scale,
    required this.ring2Opacity,
    required this.particleProgress,
  });

  static const _baseRadius = 44.0;
  static const _gold = AppColors.quinoaGold;
  static const _particleCount = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Rings d'expansion
    _drawRing(canvas, center, ring2Scale, ring2Opacity, 2.0);
    _drawRing(canvas, center, ring1Scale, ring1Opacity, 2.5);

    // Halo doux derrière le cercle
    canvas.drawCircle(
      center,
      _baseRadius * checkScale,
      Paint()..color = _gold.withValues(alpha: 0.12 * checkScale),
    );

    // Cercle principal
    canvas.drawCircle(
      center,
      _baseRadius * checkScale,
      Paint()..color = _gold,
    );

    // Coche
    if (checkScale > 0.3) {
      final t = ((checkScale - 0.3) / 0.7).clamp(0.0, 1.0);
      _drawCheck(canvas, center, _baseRadius, t);
    }

    // Particules burst
    if (particleProgress > 0) {
      _drawParticles(canvas, center, particleProgress);
    }
  }

  void _drawRing(Canvas canvas, Offset center, double scale, double opacity, double strokeWidth) {
    if (opacity <= 0) return;
    canvas.drawCircle(
      center,
      _baseRadius * scale,
      Paint()
        ..color = _gold.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  void _drawCheck(Canvas canvas, Offset center, double r, double t) {
    // Points de la coche centrée dans le cercle
    final p1 = center + Offset(-r * 0.35, 0.0);
    final p2 = center + Offset(-r * 0.08, r * 0.28);
    final p3 = center + Offset(r * 0.38, -r * 0.26);

    final path = Path()..moveTo(p1.dx, p1.dy);

    // Premier segment p1→p2
    final seg1 = 0.45;
    if (t <= seg1) {
      final tt = t / seg1;
      final mid = Offset.lerp(p1, p2, tt)!;
      path.lineTo(mid.dx, mid.dy);
    } else {
      path.lineTo(p2.dx, p2.dy);
      final tt = (t - seg1) / (1.0 - seg1);
      final mid = Offset.lerp(p2, p3, tt)!;
      path.lineTo(mid.dx, mid.dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawParticles(Canvas canvas, Offset center, double t) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < _particleCount; i++) {
      final angle = (i / _particleCount) * 2 * math.pi - math.pi / 2;
      // Taille alternée : gros / petit
      final size = i % 2 == 0 ? 5.0 : 3.5;
      final distance = _baseRadius * 1.6 + _baseRadius * 1.0 * t;
      final pos = center + Offset(math.cos(angle) * distance, math.sin(angle) * distance);
      final opacity = (1.0 - t).clamp(0.0, 1.0);
      // Alternance or / crème foncé
      paint.color = (i % 3 == 0 ? AppColors.quinoaDark : _gold).withValues(alpha: opacity);
      canvas.drawCircle(pos, size * (1.0 - t * 0.4), paint);
    }
  }

  @override
  bool shouldRepaint(_CelebrationPainter old) =>
      checkScale != old.checkScale ||
      ring1Scale != old.ring1Scale ||
      ring1Opacity != old.ring1Opacity ||
      ring2Scale != old.ring2Scale ||
      ring2Opacity != old.ring2Opacity ||
      particleProgress != old.particleProgress;
}
