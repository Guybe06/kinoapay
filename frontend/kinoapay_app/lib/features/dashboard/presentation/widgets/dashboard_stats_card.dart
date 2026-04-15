import "dart:ui";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/daily_volume.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";

/// Card statistiques mensuelles — deux courbes fluides, entrant et sortant.
class DashboardStatsCard extends StatelessWidget {
  final DashboardStats stats;

  const DashboardStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: "", decimalDigits: 0, locale: "fr_FR");
    final rawMonth = DateFormat("MMMM yyyy", "fr_FR").format(DateTime.now());
    final month    = rawMonth[0].toUpperCase() + rawMonth.substring(1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Effet de flou de fond
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: KinoaColors.quinoaRed.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
            // Bordure et Reflet
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Titre + période ──────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Activité mensuelle",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          month,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Stats entrant / sortant ───────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatBlock(
                          label: "Entrant",
                          amount: currency.format(stats.totalReceived).trim(),
                          color: const Color(0xFFFFE9C8),
                        ),
                      ),
                      Expanded(
                        child: _StatBlock(
                          label: "Sortant",
                          amount: currency.format(stats.totalSent).trim(),
                          color: const Color(0xFFE8A87C),
                          alignRight: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Double courbe fluide ──────────────────────────────────────
                  SizedBox(
                    height: 72,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _DualCurvePainter(volumes: stats.dailyVolumes),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Légende ───────────────────────────────────────────────────
                  Row(
                    children: [
                      _LegendDot(color: const Color(0xFFFFE9C8), label: "Reçu"),
                      const SizedBox(width: 16),
                      _LegendDot(color: const Color(0xFFE8A87C), label: "Envoyé"),
                      const Spacer(),
                      Text(
                        "30 derniers jours",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.60),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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

// ── Bloc stat ─────────────────────────────────────────────────────────────────

class _StatBlock extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final bool alignRight;

  const _StatBlock({
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
              Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          Text("XAF", style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Légende ───────────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ── Double courbe Catmull-Rom ─────────────────────────────────────────────────

class _DualCurvePainter extends CustomPainter {
  final List<DailyVolume> volumes;
  const _DualCurvePainter({required this.volumes});

  @override
  void paint(Canvas canvas, Size size) {
    if (volumes.length < 2) return;

    final maxVal = volumes
        .expand((v) => [v.received, v.sent])
        .reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return;

    _drawCurve(canvas, size, volumes.map((v) => v.received).toList(), maxVal, const Color(0xFFFFE9C8));
    _drawCurve(canvas, size, volumes.map((v) => v.sent).toList(),     maxVal, const Color(0xFFE8A87C));
  }

  void _drawCurve(Canvas canvas, Size size, List<double> values, double maxVal, Color color) {
    final n   = values.length;
    final dx  = size.width / (n - 1);
    final pts = List.generate(n, (i) => Offset(i * dx, size.height - (values[i] / maxVal * size.height * 0.85) - size.height * 0.05));

    // Courbe principale (Catmull-Rom → Bézier cubique)
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < n - 1; i++) {
      final p0 = i > 0     ? pts[i - 1] : pts[i];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = i < n - 2 ? pts[i + 2] : pts[i + 1];
      path.cubicTo(
        p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6,
        p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6,
        p2.dx, p2.dy,
      );
    }

    // Remplissage dégradé sous la courbe
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

    // Glow
    canvas.drawPath(path, Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));

    // Ligne principale
    canvas.drawPath(path, Paint()
      ..color = color.withValues(alpha: 0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant _DualCurvePainter old) => old.volumes != volumes;
}
