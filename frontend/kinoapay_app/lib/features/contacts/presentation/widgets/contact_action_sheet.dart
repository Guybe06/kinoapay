import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/contacts/domain/contacts_helpers.dart";
import "package:kinoapay_app/features/contacts/domain/contacts_strings.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";
import "package:kinoapay_app/features/contacts/presentation/widgets/contact_action_btn.dart";

/// Résultat retourné par le sheet au [Navigator.pop].
enum ContactAction { send, request }

/// Actions proposées au tap sur un contact déjà inscrit.
/// Affiche le profil complet, les canaux disponibles et les actions d'envoi/demande.
class ContactActionSheet extends StatelessWidget {
  final Contact contact;
  const ContactActionSheet({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final initials = ContactsHelpers.initials(contact.fullName);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: AppColors.quinoaCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.quinoaDark.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.quinoaGold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.quinoaGold,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            contact.fullName,
            style: const TextStyle(
              color: AppColors.quinoaDark,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            contact.phone,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.4),
              fontSize: 13,
            ),
          ),
          if (contact.publicHandle != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.quinoaGold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                "@${contact.publicHandle}",
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
          if (contact.channels.isNotEmpty) ...[
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ContactsStrings.channelsAvailable,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: contact.channels
                    .map((c) => _ChannelBadge(channel: c))
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ContactActionBtn(
                  label: ContactsStrings.actionSend,
                  icon: Icons.arrow_upward_rounded,
                  onTap: () => Navigator.pop(context, ContactAction.send),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ContactActionBtn(
                  label: ContactsStrings.actionRequest,
                  icon: Icons.arrow_downward_rounded,
                  secondary: true,
                  onTap: () => Navigator.pop(context, ContactAction.request),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChannelBadge extends StatelessWidget {
  final PaymentChannel channel;
  const _ChannelBadge({required this.channel});

  @override
  Widget build(BuildContext context) {
    final isMtn = channel == PaymentChannel.mtn;
    final color = AppColors.quinoaDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.30), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            isMtn ? ContactsStrings.channelMtn : ContactsStrings.channelAirtel,
            style: TextStyle(
              color: AppColors.quinoaDark,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
