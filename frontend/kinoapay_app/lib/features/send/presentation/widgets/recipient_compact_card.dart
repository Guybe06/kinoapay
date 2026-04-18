import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Pill sombre affichant le destinataire sélectionné avec initiale et bouton Modifier.
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
    final initial =
        recipient.name.isNotEmpty ? recipient.name[0].toUpperCase() : "?";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.quinoaDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildAvatar(initial),
          const SizedBox(width: 12),
          Expanded(child: _buildInfo()),
          _buildModifyBtn(),
        ],
      ),
    );
  }

  Widget _buildAvatar(String initial) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.quinoaGold,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: AppColors.quinoaCream,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
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
                  color: AppColors.quinoaCream,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
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
            color: AppColors.quinoaCream.withValues(alpha: 0.45),
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
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: isKinoa
            ? AppColors.quinoaGold.withValues(alpha: 0.25)
            : AppColors.quinoaCream.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isKinoa ? SendStrings.kinoaUserTag : SendStrings.externalUserTag,
        style: TextStyle(
          color: isKinoa
              ? AppColors.quinoaGold
              : AppColors.quinoaCream.withValues(alpha: 0.5),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildModifyBtn() {
    return GestureDetector(
      onTap: onModify,
      child: Text(
        SendStrings.modifyBtn,
        style: TextStyle(
          color: AppColors.quinoaCream.withValues(alpha: 0.5),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
