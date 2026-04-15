import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";

class DashboardTxRow extends StatelessWidget {
  final Transaction tx;
  const DashboardTxRow({super.key, required this.tx});

  _TxNature get _nature {
    final s = tx.status.toUpperCase();
    if (s == "FAILED" || s == "REJECTED" || s == "CANCELLED") return _TxNature.refused;
    if (s == "PROCESSING") return _TxNature.processing;
    if (s == "PENDING") return _TxNature.pending;
    return tx.direction == "received" ? _TxNature.received : _TxNature.sent;
  }

  @override
  Widget build(BuildContext context) {
    final bool isReceived = tx.direction == "received";
    final nature = _nature;

    final String name = isReceived
        ? (tx.senderName ?? tx.receiverIdentifier)
        : (tx.receiverName ?? tx.receiverIdentifier);

    final fmt = NumberFormat.currency(symbol: "", decimalDigits: 0, locale: "fr_FR");
    final String timeLabel = _relativeDate(tx.startedAt);
    
    // Chemin des canaux : SOURCE → DESTINATION
    final String source = tx.sourceChannel.toUpperCase();
    final String destination = tx.destinationChannel.toUpperCase();

    final Color amountColor = isReceived ? KinoaColors.accentDark : KinoaColors.quinoaRed;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Côté gauche : Nom, Identifiant et Heure
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      color: KinoaColors.quinoaDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tx.receiverIdentifier,
                    style: TextStyle(
                      color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeLabel,
                    style: TextStyle(
                      color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.4),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Centre : Mini Courbe AML et Flux des canaux
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ChannelBadge(label: source),
                      Icon(
                        SolarIconsOutline.arrowRight,
                        size: 10,
                        color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.3),
                      ),
                      _ChannelBadge(label: destination),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _AmlSparkline(score: (tx.amlScore ?? 0.1).clamp(0.0, 1.0)),
                ],
              ),
            ),

            // Côté droit : Montant et Statut
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${isReceived ? "+" : "−"} ${fmt.format(tx.amount).trim()}",
                    style: TextStyle(
                      color: amountColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _CompactStatus(nature: nature),
                  const SizedBox(height: 2),
                  Text(
                    tx.currency,
                    style: TextStyle(
                      color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.3),
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
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

// ── Badge de Canal minimaliste ────────────────────────────────────────────────

class _ChannelBadge extends StatelessWidget {
  final String label;
  const _ChannelBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: KinoaColors.quinoaDark.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: KinoaColors.quinoaDark.withValues(alpha: 0.5),
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.2,
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
  processing,
  refused;

  Color get color => switch (this) {
        _TxNature.sent       => KinoaColors.quinoaDark,
        _TxNature.received   => KinoaColors.accentDark,
        _TxNature.pending    => KinoaColors.quinoaGold,
        _TxNature.processing => const Color(0xFF2979FF),
        _TxNature.refused    => KinoaColors.quinoaRed,
      };

  String get label => switch (this) {
        _TxNature.sent       => "Envoyé",
        _TxNature.received   => "Reçu",
        _TxNature.pending    => "En attente",
        _TxNature.processing => "En traitement",
        _TxNature.refused    => "Échoué",
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
