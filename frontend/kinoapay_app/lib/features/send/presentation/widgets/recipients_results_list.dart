import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Cartes individuelles animées — chaque résultat est son propre objet flottant.
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
    return Column(
      children: [
        for (int i = 0; i < recipients.length; i++)
          _AnimatedCard(
            key: ValueKey(recipients[i].phone),
            recipient: recipients[i],
            onTap: () => onSelect(recipients[i]),
            index: i,
          ),
      ],
    );
  }
}

// ── Carte animée (fade + slide staggeré) ──────────────────────────────────────

class _AnimatedCard extends StatefulWidget {
  final RecipientMatch recipient;
  final VoidCallback onTap;
  final int index;

  const _AnimatedCard({
    super.key,
    required this.recipient,
    required this.onTap,
    required this.index,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 300);
  static const int _staggerMs = 55;

  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(
      Duration(milliseconds: widget.index * _staggerMs),
      () { if (mounted) _ctrl.forward(); },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _ResultCard(recipient: widget.recipient, onTap: widget.onTap),
        ),
      ),
    );
  }
}

// ── Carte avec press feedback ──────────────────────────────────────────────────

class _ResultCard extends StatefulWidget {
  final RecipientMatch recipient;
  final VoidCallback onTap;

  const _ResultCard({required this.recipient, required this.onTap});

  @override
  State<_ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<_ResultCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.stone200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.quinoaDark.withValues(
                  alpha: _pressed ? 0.02 : 0.05,
                ),
                blurRadius: _pressed ? 4 : 12,
                offset: Offset(0, _pressed ? 1 : 3),
              ),
            ],
          ),
          child: Row(
            children: [
              _AvatarIcon(isKinoa: widget.recipient.isKinoaUser),
              const SizedBox(width: 12),
              Expanded(child: _CardInfo(recipient: widget.recipient)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Avatar icône user ──────────────────────────────────────────────────────────

class _AvatarIcon extends StatelessWidget {
  final bool isKinoa;

  const _AvatarIcon({required this.isKinoa});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isKinoa
            ? AppColors.quinoaGold.withValues(alpha: 0.10)
            : AppColors.stone100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        SolarIconsOutline.user,
        size: 18,
        color: isKinoa ? AppColors.quinoaGold : AppColors.stone400,
      ),
    );
  }
}

// ── Infos : nom + badge + phone + comptes ─────────────────────────────────────

class _CardInfo extends StatelessWidget {
  final RecipientMatch recipient;

  const _CardInfo({required this.recipient});

  @override
  Widget build(BuildContext context) {
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
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (recipient.isKinoaUser) ...[
              const SizedBox(width: 7),
              const _KinoaBadge(),
            ],
          ],
        ),
        const SizedBox(height: 3),
        _buildMeta(),
      ],
    );
  }

  Widget _buildMeta() {
    final hasChannels = recipient.channels.isNotEmpty;
    return Row(
      children: [
        Text(
          recipient.phone,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.38),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (hasChannels) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              "·",
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.2),
                fontSize: 13,
              ),
            ),
          ),
          Text(
            SendStrings.accountsCountLabel(recipient.channels.length),
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.3),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class _KinoaBadge extends StatelessWidget {
  const _KinoaBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.quinoaGold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        SendStrings.kinoaUserTag,
        style: TextStyle(
          color: AppColors.quinoaGold,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
