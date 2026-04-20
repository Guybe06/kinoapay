import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/domain/kinoa_user_type.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Pill sombre affichant le destinataire sélectionné avec icône user et bouton Modifier.
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.quinoaDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          Expanded(child: _buildInfo()),
          _buildModifyBtn(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.quinoaGold.withValues(alpha: 0.20),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        SolarIconsOutline.user,
        size: 18,
        color: AppColors.quinoaGold,
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
    final type = recipient.userType;
    final label = switch (type) {
      KinoaUserType.individual => SendStrings.kinoaUserTag,
      KinoaUserType.merchant => SendStrings.merchantUserTag,
      KinoaUserType.external => SendStrings.externalUserTag,
    };
    final color = switch (type) {
      KinoaUserType.individual => AppColors.quinoaGold,
      KinoaUserType.merchant => AppColors.success,
      KinoaUserType.external => AppColors.quinoaCream.withValues(alpha: 0.5),
    };
    final bg = switch (type) {
      KinoaUserType.individual => AppColors.quinoaGold.withValues(alpha: 0.25),
      KinoaUserType.merchant => AppColors.success.withValues(alpha: 0.20),
      KinoaUserType.external => AppColors.quinoaCream.withValues(alpha: 0.10),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
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
