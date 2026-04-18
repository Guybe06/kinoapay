import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Liste des destinataires trouvés par la recherche ; callback sur sélection.
class RecipientsResultsList extends StatelessWidget {
  final List<RecipientMatch> recipients;
  final ValueChanged<RecipientMatch> onSelect;

  const RecipientsResultsList({
    super.key,
    required this.recipients,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.quinoaDark.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(height: 1),
          ...recipients.map(
            (r) => _RecipientTile(recipient: r, onTap: () => onSelect(r)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        SendStrings.recipientsFoundLabel(recipients.length),
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.6),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

/// Tuile d'un destinataire : initiale, nom et nombre de comptes.
class _RecipientTile extends StatelessWidget {
  final RecipientMatch recipient;
  final VoidCallback onTap;

  const _RecipientTile({required this.recipient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.quinoaDark.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            const _Avatar(),
            const SizedBox(width: 14),
            Expanded(child: _InfoColumn(recipient: recipient)),
            const Icon(
              SolarIconsOutline.altArrowRight,
              color: AppColors.quinoaGold,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.stone100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        SolarIconsOutline.user,
        color: AppColors.stone400,
        size: 20,
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final RecipientMatch recipient;
  const _InfoColumn({required this.recipient});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipient.name,
          style: const TextStyle(
            color: AppColors.quinoaDark,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          SendStrings.accountsCountLabel(recipient.channels.length),
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.5),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
