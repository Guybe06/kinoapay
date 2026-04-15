import "package:flutter/material.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/daily_volume.dart";

/// Montant « entrant » ou « sortant » avec pastille de couleur.
class DashboardStatsValueBlock extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final bool alignRight;

  const DashboardStatsValueBlock({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: alignRight ? 16 : 0, right: alignRight ? 0 : 16),
      child: Column(
        crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          Text(
            "XAF",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Pastille de légende sous le graphique.
class DashboardStatsLegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const DashboardStatsLegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Deux courbes lissées (reçu / envoyé) sur les volumes journaliers.
class DashboardStatsVolumePainter extends CustomPainter {
  final List<DailyVolume> volumes;
  const DashboardStatsVolumePainter({required this.volumes});

  @override
  void paint(Canvas canvas, Size size) {
    if (volumes.length < 2) return;

    final maxVal = volumes.expand((v) => [v.received, v.sent]).reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return;

    _drawCurve(canvas, size, volumes.map((v) => v.received).toList(), maxVal, const Color(0xFFFFE9C8));
    _drawCurve(canvas, size, volumes.map((v) => v.sent).toList(), maxVal, const Color(0xFFE8A87C));
  }

  void _drawCurve(Canvas canvas, Size size, List<double> values, double maxVal, Color color) {
    final n = values.length;
    final dx = size.width / (n - 1);
    final pts = List.generate(n, (i) => Offset(i * dx, size.height - (values[i] / maxVal * size.height * 0.85) - size.height * 0.05));

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

    final fillPath = Path.from(path)
      ..lineTo(pts.last.dx, size.height)
      ..lineTo(pts.first.dx, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.90)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant DashboardStatsVolumePainter old) => old.volumes != volumes;
}
