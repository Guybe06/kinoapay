import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";
import "package:kinoapay_app/features/contacts/domain/contacts_helpers.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";

/// Tuile de contact dans la liste, avec avatar, infos et indicateurs de canaux.
class ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;

  const ContactTile({super.key, required this.contact, this.onTap});

  @override
  Widget build(BuildContext context) {
    final initials = ContactsHelpers.initials(contact.fullName);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            _Avatar(initials: initials, onApp: contact.isRegistered),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.fullName,
                    style: const TextStyle(
                      color: AppColors.quinoaDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.phone,
                    style: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (contact.isRegistered)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...contact.channels.map((c) => _ChannelDot(channel: c)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.quinoaGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      AppStrings.appName,
                      style: TextStyle(
                        color: AppColors.quinoaGold,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Petite pastille indiquant un canal de paiement disponible.
class _ChannelDot extends StatelessWidget {
  final PaymentChannel channel;
  const _ChannelDot({required this.channel});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.quinoaDark;
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(right: 3),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  final bool onApp;

  const _Avatar({required this.initials, required this.onApp});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: onApp
                ? AppColors.quinoaGold.withValues(alpha: 0.12)
                : AppColors.quinoaDark.withValues(alpha: 0.07),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              color: onApp
                  ? AppColors.quinoaGold
                  : AppColors.quinoaDark.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (onApp)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.quinoaGold,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.quinoaCream, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}
