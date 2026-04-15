import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/accounts/domain/entities/linked_account.dart";
import "package:kinoapay_app/features/onboarding/presentation/payment_setup/payment_setup_channel_models.dart";

/// Ligne d'un compte lié : badge canal, numéro et bouton supprimer.
class PaymentSetupAccountTile extends StatelessWidget {
  final LinkedAccount account;
  final VoidCallback onRemove;

  const PaymentSetupAccountTile({
    super.key,
    required this.account,
    required this.onRemove,
  });

  PaymentSetupChannelDef? get _channelDef {
    try {
      return paymentSetupChannels.firstWhere(
        (c) => c.type == account.channelType,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ch = _channelDef;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ch?.color ?? AppColors.stone500,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              ch?.shortLabel ?? "?",
              style: TextStyle(
                color: ch?.textColor ?? Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.label,
                  style: const TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${account.countryCode} ${account.phone}",
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.45),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              SolarIconsOutline.trashBinMinimalistic,
              color: AppColors.quinoaDark.withValues(alpha: 0.35),
              size: 18,
            ),
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
