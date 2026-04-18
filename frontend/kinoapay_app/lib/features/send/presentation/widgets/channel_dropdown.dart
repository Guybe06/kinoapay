import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";

/// Dropdown réutilisable pour sélectionner un canal de paiement (source ou destination).
class ChannelDropdown extends StatelessWidget {
  final String label;
  final List<PaymentChannel> channels;
  final PaymentChannel? selected;
  final ValueChanged<PaymentChannel?> onChanged;

  const ChannelDropdown({
    super.key,
    required this.label,
    required this.channels,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.10),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PaymentChannel>(
              value: selected,
              isExpanded: true,
              icon: Icon(
                SolarIconsOutline.altArrowDown,
                size: 16,
                color: AppColors.quinoaDark.withValues(alpha: 0.4),
              ),
              hint: Text(
                label,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              dropdownColor: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              items: channels.map((ch) {
                return DropdownMenuItem<PaymentChannel>(
                  value: ch,
                  child: Text(
                    "${ch.label}  ${ch.value}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
