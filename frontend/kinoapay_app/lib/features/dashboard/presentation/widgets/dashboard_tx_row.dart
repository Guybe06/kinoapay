import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";

class DashboardTxRow extends StatelessWidget {
  final Transaction tx;
  const DashboardTxRow({super.key, required this.tx});

  _TxNature get _nature {
    final s = tx.status.toUpperCase();
    if (s == "FAILED" || s == "REJECTED" || s == "CANCELLED") return _TxNature.refused;
    if (s == "PENDING" || s == "PROCESSING") return _TxNature.pending;
    return tx.direction == "received" ? _TxNature.received : _TxNature.sent;
  }

  @override
  Widget build(BuildContext context) {
    final bool isReceived = tx.direction == "received";
    final nature = _nature;

    final String name = isReceived
        ? (tx.senderName ?? tx.receiverIdentifier)
        : (tx.receiverName ?? tx.receiverIdentifier);

    final String initials = name.isNotEmpty
        ? name.split(" ").map((n) => n[0]).take(2).join("").toUpperCase()
        : "?";

    final fmt = NumberFormat.currency(symbol: "", decimalDigits: 0, locale: "fr_FR");
    final String canal    = "${tx.sourceChannel} → ${tx.destinationChannel}";
    final String timeLabel = _relativeDate(tx.startedAt);

    final Color amountColor   = isReceived ? KinoaColors.accentDark : KinoaColors.quinoaRed;
    final Color avatarBg      = amountColor.withValues(alpha: 0.10);
    final Color avatarFg      = amountColor.withValues(alpha: 0.80);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: KinoaColors.quinoaDark.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
        child: Column(
          children: [
            // ── Zone principale : avatar + nom + montant ──────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar teinté selon direction
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(color: avatarBg, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: avatarFg,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Nom
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: KinoaColors.quinoaDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: 10),

                // Montant + XAF
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${isReceived ? "+" : "−"} ${fmt.format(tx.amount).trim()}",
                      style: TextStyle(
                        color: amountColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                      ),
                    ),
                    Text(
                      tx.currency,
                      style: TextStyle(
                        color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.40),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Séparateur ────────────────────────────────────────────────
            Container(height: 1, color: KinoaColors.quinoaDark.withValues(alpha: 0.05)),

            const SizedBox(height: 9),

            // ── Zone secondaire : canal + numéro | date + statut + AML ───
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Canal + identifiant
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        canal,
                        style: TextStyle(
                          color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.65),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tx.receiverIdentifier,
                        style: TextStyle(
                          color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.42),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Date + statut + AML
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      timeLabel,
                      style: TextStyle(
                        color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.42),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 7),
                    _CompactStatus(nature: nature),
                    if (tx.amlScore != null) ...[
                      const SizedBox(width: 10),
                      _AmlSparkline(score: tx.amlScore!),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Date relative ─────────────────────────────────────────────────────────────

String _relativeDate(DateTime dt) {
  final now  = DateTime.now();
  final diff = now.difference(dt);

  if (diff.inMinutes < 1)  return "À l'instant";
  if (diff.inMinutes < 60) return "il y a ${diff.inMinutes} min";

  final today     = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dtDay     = DateTime(dt.year, dt.month, dt.day);
  final hhmm      = DateFormat("HH:mm", "fr_FR").format(dt);

  if (dtDay == today)     return "Aujourd'hui $hhmm";
  if (dtDay == yesterday) return "Hier $hhmm";
  if (diff.inDays < 7) {
    final day = DateFormat("EEE.", "fr_FR").format(dt);
    return "${day[0].toUpperCase()}${day.substring(1)} $hhmm";
  }

  final d = DateFormat("EEE. d MMM", "fr_FR").format(dt);
  return "${d[0].toUpperCase()}${d.substring(1)}";
}

// ── Nature enum ───────────────────────────────────────────────────────────────

enum _TxNature {
  sent,
  received,
  pending,
  refused;

  Color get color => switch (this) {
        _TxNature.sent     => KinoaColors.quinoaRed,
        _TxNature.received => KinoaColors.accentDark,
        _TxNature.pending  => KinoaColors.warning,
        _TxNature.refused  => KinoaColors.quinoaRed,
      };

  String get label => switch (this) {
        _TxNature.sent     => "Envoyé",
        _TxNature.received => "Reçu",
        _TxNature.pending  => "En attente",
        _TxNature.refused  => "Refusé",
      };
}

// ── Statut pill ───────────────────────────────────────────────────────────────

class _CompactStatus extends StatelessWidget {
  final _TxNature nature;
  const _CompactStatus({required this.nature});

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

// ── Sparkline AML ─────────────────────────────────────────────────────────────

class _AmlSparkline extends StatelessWidget {
  final double score;
  const _AmlSparkline({required this.score});

  Color get _color {
    if (score < 0.35) return KinoaColors.accentDark;
    if (score < 0.65) return KinoaColors.quinoaGold;
    return KinoaColors.quinoaRed;
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
            color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.40),
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
            painter: _SparklinePainter(points: _points, color: _color),
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

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;
  const _SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final n = points.length;
    if (n < 2) return;

    final dx  = size.width / (n - 1);
    final pts = List.generate(
      n,
      (i) => Offset(
        i * dx,
        size.height - (points[i] * size.height * 0.78) - size.height * 0.11,
      ),
    );

    // Fill dégradé
    final fillPath = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < n - 1; i++) {
      final p0 = i > 0     ? pts[i - 1] : pts[i];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = i < n - 2 ? pts[i + 2] : pts[i + 1];
      fillPath.cubicTo(
        p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6,
        p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6,
        p2.dx, p2.dy,
      );
    }
    final fill = Path.from(fillPath)
      ..lineTo(pts.last.dx, size.height)
      ..lineTo(pts.first.dx, size.height)
      ..close();
    canvas.drawPath(fill, Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill);

    // Courbe Catmull-Rom
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
    canvas.drawPath(path, Paint()
      ..color = color.withValues(alpha: 0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round);

    // Point terminal
    canvas.drawCircle(pts.last, 2.2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.points != points || old.color != color;
}
