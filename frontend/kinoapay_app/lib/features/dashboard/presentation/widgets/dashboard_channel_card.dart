import "dart:math" as math;
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/utils/amount_formatter.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/channel_stat.dart";

/// Carte d'un canal de paiement — style terminal financier.
/// Affiche une sparkline, le volume total, le ratio et le nombre d'opérations.
class DashboardChannelCard extends StatelessWidget {
  final ChannelStat stat;
  final double sharePercent;

  const DashboardChannelCard({
    super.key,
    required this.stat,
    required this.sharePercent,
  });

  static Color brandColor(String type) => switch (type) {
    "MTN" => const Color(0xFFFFBB00),
    "AIRTEL" => const Color(0xFFFF3D1C),
    _ => AppColors.quinoaGold,
  };

  @override
  Widget build(BuildContext context) {
    final brand = brandColor(stat.type);
    final isPositive = stat.net >= 0;
    final netColor = isPositive
        ? const Color(0xFF00C48C)
        : const Color(0xFFFF3D1C);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: AppColors.quinoaDark.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: brand, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  stat.type,
                  style: const TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: netColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${isPositive ? "↑" : "↓"} ${(sharePercent * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                    color: netColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: stat.sparkPoints.length >= 2
                ? CustomPaint(
                    size: const Size(double.infinity, 52),
                    painter: _SparklinePainter(
                      points: stat.sparkPoints,
                      color: brand,
                    ),
                  )
                : Center(
                    child: Container(height: 1, color: brand.withValues(alpha: 0.25)),
                  ),
          ),
          const SizedBox(height: 10),
          Text(
            AmountFormatter.compactWithCurrency(stat.total),
            style: const TextStyle(
              color: AppColors.quinoaDark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DashboardStrings.txCountLabel(stat.txCount),
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.38),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: sharePercent,
              minHeight: 3,
              backgroundColor: brand.withValues(alpha: 0.10),
              valueColor: AlwaysStoppedAnimation<Color>(brand.withValues(alpha: 0.60)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Courbe lissée (Catmull-Rom) avec remplissage dégradé et point terminal.
class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  const _SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final n = points.length;
    final maxVal = points.reduce(math.max);
    if (maxVal == 0) return;

    final dx = size.width / (n - 1);
    final pts = List.generate(n, (i) => Offset(
      i * dx,
      size.height - (points[i] / maxVal) * size.height * 0.85 - size.height * 0.05,
    ));

    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < n - 1; i++) {
      final p0 = i > 0 ? pts[i - 1] : pts[i];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = i < n - 2 ? pts[i + 2] : pts[i + 1];
      path.cubicTo(
        p1.dx + (p2.dx - p0.dx) / 5, p1.dy + (p2.dy - p0.dy) / 5,
        p2.dx - (p3.dx - p1.dx) / 5, p2.dy - (p3.dy - p1.dy) / 5,
        p2.dx, p2.dy,
      );
    }

    final fill = Path.from(path)
      ..lineTo(pts.last.dx, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fill, Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill);

    canvas.drawPath(path, Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round);

    canvas.drawCircle(pts.last, 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.points != points || old.color != color;
}
