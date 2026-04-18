import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";

/// Sélecteur horizontal de canaux de paiement sous forme de chips tapables.
class ChannelChipSelector extends StatelessWidget {
  final String label;
  final List<PaymentChannel> channels;
  final PaymentChannel? selected;
  final ValueChanged<PaymentChannel> onSelected;

  const ChannelChipSelector({
    super.key,
    required this.label,
    required this.channels,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        const SizedBox(height: 8),
        Wrap(spacing: 10, runSpacing: 10, children: channels.map(_buildChip).toList()),
      ],
    );
  }

  Widget _buildLabel() {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.quinoaDark.withValues(alpha: 0.55),
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildChip(PaymentChannel ch) {
    final isActive = selected?.id == ch.id;
    return GestureDetector(
      onTap: () => onSelected(ch),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.quinoaDark : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? AppColors.quinoaDark
                : AppColors.quinoaDark.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(ch, isActive),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ch.short,
                  style: TextStyle(
                    color: isActive ? AppColors.white : AppColors.quinoaDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (ch.value.isNotEmpty)
                  Text(
                    ch.value,
                    style: TextStyle(
                      color: isActive
                          ? AppColors.white.withValues(alpha: 0.7)
                          : AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(PaymentChannel ch, bool isActive) {
    final dotColor = _channelColor(ch.short);
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? dotColor : dotColor.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _channelColor(String short) {
    final key = short.toUpperCase();
    if (key.contains("MTN")) return AppColors.mtnYellow;
    if (key.contains("AIRTEL")) return AppColors.airtelRed;
    if (key.contains("ORANGE")) return const Color(0xFFFF6600);
    if (key.contains("VISA") || key.contains("MC")) return const Color(0xFF1A1F71);
    return AppColors.quinoaGold;
  }
}
