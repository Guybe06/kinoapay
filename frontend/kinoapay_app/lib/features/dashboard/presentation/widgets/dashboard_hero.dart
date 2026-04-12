import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";

class DashboardHero extends StatelessWidget {
  final String displayName;
  final String initials;
  final double totalSent;
  final double totalReceived;
  final List<PaymentChannel> channels;
  final VoidCallback onPeriodClick;
  final Function(dynamic)? onChannelSelect;

  const DashboardHero({
    super.key,
    required this.displayName,
    required this.initials,
    required this.totalSent,
    required this.totalReceived,
    required this.channels,
    required this.onPeriodClick,
    this.onChannelSelect,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    // 56 = hauteur du KinoaHeader (extendBodyBehindAppBar: true → le body passe derrière)
    return Container(
      padding: EdgeInsets.fromLTRB(20, topInset + 56 + 16, 20, 20),
      decoration: const BoxDecoration(
        color: KinoaColors.stone950,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bienvenue,",
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                  ),
                  Text(
                    displayName,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              _ProfileAvatar(initials: initials),
            ],
          ),
          const SizedBox(height: 32),

          // Carte de solde — fond quinoaDark chaud, chiffres en blanc, label XAF en or
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3A2E1E), Color(0xFF1E180E)],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: KinoaColors.quinoaGold.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Solde actuel",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    _GlassChipSmall(
                      onTap: onPeriodClick,
                      child: Text(
                        DateFormat("MMMM", "fr_FR").format(DateTime.now()),
                        style: const TextStyle(
                          color: KinoaColors.quinoaGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      NumberFormat.currency(symbol: "", decimalDigits: 0, locale: "fr_FR").format(totalReceived).trim(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "XAF",
                      style: TextStyle(
                        color: KinoaColors.quinoaGold,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _ActionButton(
                      label: "ENVOYER",
                      icon: CupertinoIcons.arrow_up_right,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      label: "RECEVOIR",
                      icon: CupertinoIcons.arrow_down_left,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: KinoaColors.quinoaGold),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassChipSmall extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassChipSmall({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: KinoaColors.quinoaGold.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: KinoaColors.quinoaGold.withValues(alpha: 0.2)),
        ),
        child: child,
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String initials;
  const _ProfileAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFC8964A), Color(0xFF8E6A34)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC8964A).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
      ),
    );
  }
}
