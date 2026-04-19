import "dart:math" as math;
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_tx_detail_sheet.dart";

/// Ligne d'une transaction avec route canal, identifiant, montant et score AML.
class HistoryTxRow extends StatelessWidget {
  final Transaction tx;

  const HistoryTxRow({super.key, required this.tx});

  static Color _channelColor(String channel) => switch (channel) {
    "MTN" => AppColors.mtnYellow,
    "AIRTEL" => AppColors.airtelRed,
    _ => AppColors.quinoaGold,
  };

  static Color _amlColor(double score) {
    if (score < 0.40) return AppColors.success;
    if (score < 0.70) return AppColors.warning;
    return AppColors.quinoaRed;
  }

  @override
  Widget build(BuildContext context) {
    final isSent = tx.direction == "sent";
    final fmt = NumberFormat("#,###", "fr_FR");
    final timeFmt = DateFormat("HH:mm", "fr_FR");
    final name = isSent
        ? (tx.receiverName ?? tx.receiverIdentifier)
        : (tx.senderName ?? tx.receiverIdentifier);
    final identifier = isSent ? tx.receiverIdentifier : tx.receiverIdentifier;
    final amountColor = isSent ? AppColors.quinoaDark : AppColors.accentDark;
    final sign = isSent ? "−" : "+";
    final aml = tx.amlScore ?? 0.0;

    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => HistoryTxDetailSheet(tx: tx),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            _ChannelDot(src: tx.sourceChannel, dest: tx.destinationChannel),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.quinoaDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    identifier,
                    style: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.40),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                          color: _channelColor(tx.sourceChannel),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${tx.sourceChannel} → ${tx.destinationChannel}",
                        style: TextStyle(
                          color: AppColors.quinoaDark.withValues(alpha: 0.35),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeFmt.format(tx.startedAt),
                        style: TextStyle(
                          color: AppColors.quinoaDark.withValues(alpha: 0.25),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$sign ${fmt.format(tx.amount)} XAF",
                  style: TextStyle(
                    color: amountColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                _AmlBadge(score: aml, color: _amlColor(aml)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Double dot superposé représentant la route source → destination.
class _ChannelDot extends StatelessWidget {
  final String src;
  final String dest;

  const _ChannelDot({required this.src, required this.dest});

  static Color _color(String ch) => switch (ch) {
    "MTN" => AppColors.mtnYellow,
    "AIRTEL" => AppColors.airtelRed,
    _ => AppColors.quinoaGold,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        children: [
          Positioned(
            left: 0, bottom: 0,
            child: Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: _color(dest),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: Text(dest[0], style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
            ),
          ),
          Positioned(
            right: 0, top: 0,
            child: Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: _color(src),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: Text(src[0], style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge circulaire AML avec arc de couleur selon le risque.
class _AmlBadge extends StatelessWidget {
  final double score;
  final Color color;

  const _AmlBadge({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    final label = (score * 100).round().toString();

    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(
        painter: _ArcPainter(score: score, color: color),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double score;
  final Color color;

  const _ArcPainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    final bg = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, bg);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * score, false, fg);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) => old.score != score || old.color != color;
}
