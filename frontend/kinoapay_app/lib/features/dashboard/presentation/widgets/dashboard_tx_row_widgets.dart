import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_row_models.dart";

/// Pastille texte du nom d’un canal (source ou destination).
class DashboardTxChannelBadge extends StatelessWidget {
  final String label;
  const DashboardTxChannelBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: AppColors.quinoaDark.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.5),
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Pastille de statut compacte sous le montant.
class DashboardTxCompactStatus extends StatelessWidget {
  final DashboardTxNature nature;
  const DashboardTxCompactStatus({super.key, required this.nature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: nature.color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: nature.color.withValues(alpha: 0.18)),
      ),
      child: Text(
        nature.label,
        style: TextStyle(
          color: nature.color.withValues(alpha: 0.85),
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Mini courbe indicative liée au score AML affiché.
class DashboardTxAmlSparkline extends StatelessWidget {
  final double score;
  const DashboardTxAmlSparkline({super.key, required this.score});

  Color get _color {
    if (score < 0.35) return AppColors.accentDark;
    if (score < 0.65) return AppColors.quinoaGold;
    return AppColors.quinoaRed;
  }

  List<double> get _points {
    if (score < 0.35) {
      return [
        (score + 0.40).clamp(0.0, 1.0),
        (score + 0.28).clamp(0.0, 1.0),
        (score + 0.18).clamp(0.0, 1.0),
        (score + 0.07).clamp(0.0, 1.0),
        score,
      ];
    } else if (score > 0.65) {
      return [
        (score - 0.38).clamp(0.0, 1.0),
        (score - 0.24).clamp(0.0, 1.0),
        (score - 0.14).clamp(0.0, 1.0),
        (score - 0.05).clamp(0.0, 1.0),
        score,
      ];
    } else {
      return [
        (score - 0.06).clamp(0.0, 1.0),
        (score + 0.09).clamp(0.0, 1.0),
        (score - 0.04).clamp(0.0, 1.0),
        (score + 0.05).clamp(0.0, 1.0),
        score,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "AML",
          style: TextStyle(
            color: AppColors.quinoaWarmGray.withValues(alpha: 0.40),
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 42,
          height: 18,
          child: CustomPaint(
            painter: DashboardTxSparklinePainter(points: _points, color: _color),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          "${(score * 100).round()}",
          style: TextStyle(
            color: _color,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

/// Courbe lissée type spline pour la sparkline AML.
class DashboardTxSparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;
  const DashboardTxSparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final n = points.length;
    if (n < 2) return;

    final dx = size.width / (n - 1);
    final pts = List.generate(
      n,
      (i) => Offset(
        i * dx,
        size.height - (points[i] * size.height * 0.78) - size.height * 0.11,
      ),
    );

    final fillPath = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < n - 1; i++) {
      final p0 = i > 0 ? pts[i - 1] : pts[i];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = i < n - 2 ? pts[i + 2] : pts[i + 1];
      fillPath.cubicTo(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
        p2.dx,
        p2.dy,
      );
    }
    final fill = Path.from(fillPath)
      ..lineTo(pts.last.dx, size.height)
      ..lineTo(pts.first.dx, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );

    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < n - 1; i++) {
      final p0 = i > 0 ? pts[i - 1] : pts[i];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = i < n - 2 ? pts[i + 2] : pts[i + 1];
      path.cubicTo(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
        p2.dx,
        p2.dy,
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.90)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(pts.last, 2.2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant DashboardTxSparklinePainter old) =>
      old.points != points || old.color != color;
}
