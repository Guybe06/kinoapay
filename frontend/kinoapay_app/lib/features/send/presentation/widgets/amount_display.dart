import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Affiche le montant saisi en grand, désactivé (lecture seule).
class AmountDisplay extends StatelessWidget {
  static final NumberFormat _fmt = NumberFormat("#,##0.########", "en_US");
  static const String _zero = "0";

  final String rawAmount;

  const AmountDisplay({super.key, required this.rawAmount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          SendStrings.amountDisplayLabel,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              _formatAmount(rawAmount),
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.45),
                fontSize: 48,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              SendStrings.amountUnit,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ],
    );
  }

  /// Met en forme le montant avec séparateur de milliers en préservant la décimale en cours.
  String _formatAmount(String raw) {
    if (raw == _zero || raw.isEmpty) return _zero;
    final n = double.tryParse(raw);
    if (n == null) return raw;
    if (raw.endsWith(".")) return "${_fmt.format(n)}.";
    final parts = raw.split(".");
    if (parts.length == 2) {
      return "${_fmt.format(n).split(".").first}.${parts[1]}";
    }
    return _fmt.format(n);
  }
}
