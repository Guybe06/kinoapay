import "dart:math" as math;
import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Écran affiché après confirmation — animation courbe nombre d'or + cercle await + texte fade-in.
class SendSuccessStep extends StatefulWidget {
  final VoidCallback onClose;

  const SendSuccessStep({super.key, required this.onClose});

  @override
  State<SendSuccessStep> createState() => _SendSuccessStepState();
}

class _SendSuccessStepState extends State<SendSuccessStep>
    with TickerProviderStateMixin {
  late final AnimationController _curveCtrl;
  late final AnimationController _circleCtrl;
  late final AnimationController _textCtrl;
  late final Animation<double> _curveProgress;
  late final Animation<double> _circleScale;
  late final Animation<double> _circleFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _curveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _circleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _curveProgress = CurvedAnimation(
      parent: _curveCtrl,
      curve: Curves.easeInOut,
    );
    _circleScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _circleCtrl, curve: Curves.elasticOut));
    _circleFade = CurvedAnimation(parent: _circleCtrl, curve: Curves.easeOut);
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));

    _curveCtrl.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      _circleCtrl.forward();
      Future.delayed(const Duration(milliseconds: 300), _textCtrl.forward);
    });
  }

  @override
  void dispose() {
    _curveCtrl.dispose();
    _circleCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildCurveAnimation(),
              const SizedBox(height: 32),
              _buildContent(),
              const Spacer(flex: 3),
              _buildCloseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurveAnimation() {
    return SizedBox(
      width: 120,
      height: 120,
      child: AnimatedBuilder(
        animation: _curveCtrl,
        builder: (_, __) {
          return CustomPaint(
            painter: _GoldenRatioCurvePainter(progress: _curveProgress.value),
            child: Center(
              child: FadeTransition(
                opacity: _circleFade,
                child: ScaleTransition(
                  scale: _circleScale,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.quinoaGold.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      SolarIconsOutline.hourglass,
                      color: AppColors.quinoaGold,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _textFade,
      child: SlideTransition(
        position: _textSlide,
        child: Column(
          children: [
            const Text(
              SendStrings.successTitle,
              style: TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              SendStrings.successMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: widget.onClose,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.quinoaDark,
          foregroundColor: AppColors.quinoaCream,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          SendStrings.successBackBtn,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }
}

class _GoldenRatioCurvePainter extends CustomPainter {
  final double progress;

  _GoldenRatioCurvePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.quinoaGold.withValues(alpha: 0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final phi = 1.618;
    final maxAngle = 2 * math.pi * phi;
    final currentAngle = maxAngle * progress;

    for (double i = 0; i <= currentAngle; i += 0.1) {
      final radius = 40 * math.pow(i / (2 * math.pi * phi), 0.5);
      final x = center.dx + radius * math.cos(i);
      final y = center.dy + radius * math.sin(i);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_GoldenRatioCurvePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
