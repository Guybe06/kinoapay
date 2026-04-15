import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";

/// Tuile de contact dans la liste, avec avatar, infos et indicateurs de canaux.
class ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;

  const ContactTile({super.key, required this.contact, this.onTap});

  @override
  Widget build(BuildContext context) {
    final initials = _initials(contact.fullName);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            _Avatar(initials: initials, onApp: contact.isOnKinoaPay),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.fullName,
                    style: const TextStyle(
                      color: KinoaColors.quinoaDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.phone,
                    style: TextStyle(
                      color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.65),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (contact.isOnKinoaPay)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...contact.channels.map((c) => _ChannelDot(channel: c)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: KinoaColors.quinoaRed.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      "KinoaPay",
                      style: TextStyle(
                        color: KinoaColors.quinoaRed,
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

  String _initials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length >= 2) return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : "?";
  }
}

/// Petite pastille colorée indiquant un canal (MTN jaune, Airtel rouge).
class _ChannelDot extends StatelessWidget {
  final PaymentChannel channel;
  const _ChannelDot({required this.channel});

  @override
  Widget build(BuildContext context) {
    final color = channel == PaymentChannel.mtn ? KinoaColors.mtnYellow : KinoaColors.airtelRed;
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
                ? KinoaColors.quinoaRed.withValues(alpha: 0.10)
                : KinoaColors.quinoaDark.withValues(alpha: 0.07),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              color: onApp ? KinoaColors.quinoaRed : KinoaColors.quinoaWarmGray,
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
                color: KinoaColors.quinoaRed,
                shape: BoxShape.circle,
                border: Border.all(color: KinoaColors.quinoaCream, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}
