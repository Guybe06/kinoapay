import "dart:math" as math;
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Animation check + anneaux + particules pour l'écran post-inscription.
class CelebrationPainter extends CustomPainter {
  final double checkScale;
  final double ring1Scale;
  final double ring1Opacity;
  final double ring2Scale;
  final double ring2Opacity;
  final double particleProgress;

  const CelebrationPainter({
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

    _drawRing(canvas, center, ring2Scale, ring2Opacity, 2.0);
    _drawRing(canvas, center, ring1Scale, ring1Opacity, 2.5);

    canvas.drawCircle(
      center,
      _baseRadius * checkScale,
      Paint()..color = _gold.withValues(alpha: 0.12 * checkScale),
    );

    canvas.drawCircle(
      center,
      _baseRadius * checkScale,
      Paint()..color = _gold,
    );

    if (checkScale > 0.3) {
      final t = ((checkScale - 0.3) / 0.7).clamp(0.0, 1.0);
      _drawCheck(canvas, center, _baseRadius, t);
    }

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
    final p1 = center + Offset(-r * 0.35, 0.0);
    final p2 = center + Offset(-r * 0.08, r * 0.28);
    final p3 = center + Offset(r * 0.38, -r * 0.26);

    final path = Path()..moveTo(p1.dx, p1.dy);

    const seg1 = 0.45;
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
      final dotSize = i % 2 == 0 ? 5.0 : 3.5;
      final distance = _baseRadius * 1.6 + _baseRadius * 1.0 * t;
      final pos = center + Offset(math.cos(angle) * distance, math.sin(angle) * distance);
      final opacity = (1.0 - t).clamp(0.0, 1.0);
      paint.color = (i % 3 == 0 ? AppColors.quinoaDark : _gold).withValues(alpha: opacity);
      canvas.drawCircle(pos, dotSize * (1.0 - t * 0.4), paint);
    }
  }

  @override
  bool shouldRepaint(CelebrationPainter old) =>
      checkScale != old.checkScale ||
      ring1Scale != old.ring1Scale ||
      ring1Opacity != old.ring1Opacity ||
      ring2Scale != old.ring2Scale ||
      ring2Opacity != old.ring2Opacity ||
      particleProgress != old.particleProgress;
}
