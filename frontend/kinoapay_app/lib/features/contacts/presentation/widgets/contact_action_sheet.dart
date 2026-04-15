import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";

/// Résultat retourné par le sheet au [Navigator.pop].
enum ContactAction { send, request }

/// Actions proposées au tap sur un contact déjà inscrit.
/// Affiche le profil complet, les canaux disponibles et les actions d'envoi/demande.
class ContactActionSheet extends StatelessWidget {
  final Contact contact;
  const ContactActionSheet({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final initials = _initials(contact.fullName);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: KinoaColors.quinoaCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            decoration: BoxDecoration(color: KinoaColors.quinoaDark.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: KinoaColors.quinoaRed.withValues(alpha: 0.10), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(initials, style: const TextStyle(color: KinoaColors.quinoaRed, fontSize: 20, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          Text(contact.fullName, style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: -0.4)),
          const SizedBox(height: 3),
          Text(contact.phone, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 13)),
          if (contact.kinoaId != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: KinoaColors.quinoaGold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
              child: Text("@${contact.kinoaId}", style: const TextStyle(color: KinoaColors.quinoaGold, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.2)),
            ),
          ],
          if (contact.channels.isNotEmpty) ...[
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "CANAUX DISPONIBLES",
                style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(spacing: 8, children: contact.channels.map((c) => _ChannelBadge(channel: c)).toList()),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _ActionBtn(label: "Envoyer", icon: Icons.arrow_upward_rounded, onTap: () => Navigator.pop(context, ContactAction.send))),
              const SizedBox(width: 12),
              Expanded(child: _ActionBtn(label: "Demander", icon: Icons.arrow_downward_rounded, secondary: true, onTap: () => Navigator.pop(context, ContactAction.request))),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length >= 2) return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : "?";
  }
}

class _ChannelBadge extends StatelessWidget {
  final PaymentChannel channel;
  const _ChannelBadge({required this.channel});

  @override
  Widget build(BuildContext context) {
    final isMtn = channel == PaymentChannel.mtn;
    final color = isMtn ? KinoaColors.mtnYellow : KinoaColors.airtelRed;
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
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(
            isMtn ? "MTN Mobile Money" : "Airtel Money",
            style: TextStyle(color: isMtn ? KinoaColors.quinoaDark : KinoaColors.airtelRed, fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool secondary;
  final VoidCallback onTap;
  const _ActionBtn({required this.label, required this.icon, required this.onTap, this.secondary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: secondary ? KinoaColors.quinoaDark.withValues(alpha: 0.06) : KinoaColors.quinoaDark,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: secondary ? KinoaColors.quinoaDark : Colors.white),
            const SizedBox(width: 7),
            Text(label, style: TextStyle(color: secondary ? KinoaColors.quinoaDark : Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
