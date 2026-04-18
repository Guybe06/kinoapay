import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Carte compacte affichant le destinataire résolu avec un bouton Modifier.
class RecipientCompactCard extends StatelessWidget {
  final RecipientMatch recipient;
  final VoidCallback onModify;

  const RecipientCompactCard({
    super.key,
    required this.recipient,
    required this.onModify,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.quinoaDark.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 14),
          Expanded(child: _buildInfo()),
          _buildModifyBtn(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
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

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                recipient.name,
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _buildTag(),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          recipient.phone,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.5),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTag() {
    final isKinoa = recipient.isKinoaUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isKinoa
            ? AppColors.quinoaGold.withValues(alpha: 0.12)
            : AppColors.stone100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isKinoa ? SendStrings.kinoaUserTag : SendStrings.externalUserTag,
        style: TextStyle(
          color: isKinoa ? AppColors.quinoaGold : AppColors.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildModifyBtn() {
    return GestureDetector(
      onTap: onModify,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          SendStrings.modifyBtn,
          style: TextStyle(
            color: AppColors.quinoaDark,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
