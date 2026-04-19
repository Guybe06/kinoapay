import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/history/application/bloc/history_state.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";

/// Barre de résumé financier pour la période filtrée — style terminal.
class HistoryStatsBar extends StatelessWidget {
  final HistoryLoadSuccess state;

  const HistoryStatsBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.compact(locale: "fr_FR");
    final isPositive = state.net >= 0;
    final netColor = isPositive ? AppColors.accentDark : AppColors.quinoaRed;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.quinoaDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _StatCell(
            label: HistoryStrings.statsSent,
            value: "${fmt.format(state.totalSent)} XAF",
            icon: "↑",
            color: AppColors.quinoaCream.withValues(alpha: 0.65),
          ),
          _Divider(),
          _StatCell(
            label: HistoryStrings.statsReceived,
            value: "${fmt.format(state.totalReceived)} XAF",
            icon: "↓",
            color: AppColors.quinoaGold,
            center: true,
          ),
          _Divider(),
          _StatCell(
            label: HistoryStrings.statsNet,
            value: "${isPositive ? "+" : "−"}${fmt.format(state.net.abs())} XAF",
            icon: "=",
            color: netColor,
            alignRight: true,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1, height: 36,
    color: AppColors.quinoaCream.withValues(alpha: 0.08),
  );
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;
  final bool center;
  final bool alignRight;

  const _StatCell({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.center = false,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final cross = alignRight
        ? CrossAxisAlignment.end
        : center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final pad = EdgeInsets.only(
      left: center || alignRight ? 14 : 0,
      right: center || !alignRight ? 14 : 0,
    );

    return Expanded(
      child: Padding(
        padding: pad,
        child: Column(
          crossAxisAlignment: cross,
          children: [
            Row(
              mainAxisAlignment: alignRight
                  ? MainAxisAlignment.end
                  : center ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Text(icon, style: TextStyle(color: color.withValues(alpha: 0.60), fontSize: 10)),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(color: color.withValues(alpha: 0.50), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: -0.3),
            ),
          ],
        ),
      ),
    );
  }
}
