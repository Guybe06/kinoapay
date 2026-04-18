import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Palette d'avatars — tons chauds cohérents avec la brand.
const List<Color> _avatarPalette = [
  Color(0xFFC8964A),
  Color(0xFF8B3A2F),
  Color(0xFF7A6A55),
  Color(0xFF44403C),
  Color(0xFF57534E),
  Color(0xFFB07A3A),
];

Color _colorFor(String name) {
  final hash = name.codeUnits.fold(0, (a, b) => a + b);
  return _avatarPalette[hash % _avatarPalette.length];
}

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
          padding: const EdgeInsets.only(bottom: 10),
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
    final color = _colorFor(widget.recipient.name);
    final initial = widget.recipient.name.isNotEmpty
        ? widget.recipient.name[0].toUpperCase()
        : "?";

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.quinoaDark.withValues(
                  alpha: _pressed ? 0.03 : 0.07,
                ),
                blurRadius: _pressed ? 4 : 16,
                offset: Offset(0, _pressed ? 1 : 5),
              ),
            ],
          ),
          child: Row(
            children: [
              _Avatar(initial: initial, color: color),
              const SizedBox(width: 14),
              Expanded(child: _CardInfo(recipient: widget.recipient, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Avatar cercle coloré ───────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String initial;
  final Color color;

  const _Avatar({required this.initial, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

// ── Infos : nom + badge + phone + comptes ─────────────────────────────────────

class _CardInfo extends StatelessWidget {
  final RecipientMatch recipient;
  final Color color;

  const _CardInfo({required this.recipient, required this.color});

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
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (recipient.isKinoaUser) ...[
              const SizedBox(width: 8),
              _KinoaBadge(),
            ],
          ],
        ),
        const SizedBox(height: 4),
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
            color: AppColors.quinoaDark.withValues(alpha: 0.4),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (hasChannels) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Text(
              "·",
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.2),
                fontSize: 14,
              ),
            ),
          ),
          Text(
            SendStrings.accountsCountLabel(recipient.channels.length),
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.35),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.quinoaGold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        SendStrings.kinoaUserTag,
        style: TextStyle(
          color: AppColors.quinoaGold,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
