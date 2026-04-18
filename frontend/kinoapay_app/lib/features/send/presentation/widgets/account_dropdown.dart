import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Sélecteur de compte de paiement, avec label au-dessus.
class AccountDropdown extends StatelessWidget {
  final String label;
  final PaymentChannel? value;
  final List<PaymentChannel> accounts;
  final ValueChanged<PaymentChannel?> onChanged;

  const AccountDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.accounts,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        _buildDropdown(),
      ],
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.55),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.quinoaDark.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PaymentChannel>(
          value: value,
          isExpanded: true,
          hint: const Text(
            SendStrings.dropdownHint,
            style: TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          icon: const Icon(
            SolarIconsOutline.altArrowDown,
            color: AppColors.quinoaDark,
            size: 20,
          ),
          borderRadius: BorderRadius.circular(20),
          items: accounts.map(_buildItem).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  DropdownMenuItem<PaymentChannel> _buildItem(PaymentChannel ch) {
    return DropdownMenuItem<PaymentChannel>(
      value: ch,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.stone100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              SolarIconsOutline.card,
              color: AppColors.stone400,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ch.type,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              Text(
                ch.value,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
