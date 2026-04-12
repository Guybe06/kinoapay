import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
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
    // 56 = KinoaHeader height (extendBodyBehindAppBar: true)
    return Container(
      padding: EdgeInsets.fromLTRB(20, topInset + 56 + 16, 20, 24),
      color: KinoaColors.quinoaCream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salutation + avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bonjour,",
                    style: TextStyle(
                      color: KinoaColors.quinoaWarmGray,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    displayName.isNotEmpty ? displayName : "—",
                    style: const TextStyle(
                      color: KinoaColors.quinoaDark,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              _ProfileAvatar(initials: initials),
            ],
          ),
          const SizedBox(height: 24),

          // Carte de solde — blanche sur fond quinoaCream, ombre douce
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: KinoaColors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: KinoaColors.quinoaDark.withValues(alpha: 0.07),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: KinoaColors.quinoaDark.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label + sélecteur de période
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Solde actuel",
                      style: TextStyle(
                        color: KinoaColors.quinoaWarmGray,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    _PeriodChip(
                      label: DateFormat("MMMM", "fr_FR").format(DateTime.now()),
                      onTap: onPeriodClick,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Montant principal
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      NumberFormat.currency(
                        symbol: "",
                        decimalDigits: 0,
                        locale: "fr_FR",
                      ).format(totalReceived).trim(),
                      style: const TextStyle(
                        color: KinoaColors.quinoaDark,
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "XAF",
                      style: TextStyle(
                        color: KinoaColors.quinoaGold,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                // Mini stats envoyé / reçu
                const SizedBox(height: 14),
                Row(
                  children: [
                    _MiniStat(
                      icon: SolarIconsOutline.arrowRightUp,
                      label: "Envoyé",
                      amount: totalSent,
                      color: KinoaColors.quinoaRed,
                    ),
                    const SizedBox(width: 20),
                    _MiniStat(
                      icon: SolarIconsOutline.arrowLeftDown,
                      label: "Reçu",
                      amount: totalReceived,
                      color: KinoaColors.success,
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // Boutons d'action
                Row(
                  children: [
                    _ActionBtn(
                      icon: SolarIconsOutline.plain,
                      label: "Envoyer",
                      onTap: () {},
                    ),
                    const SizedBox(width: 10),
                    _ActionBtn(
                      icon: SolarIconsOutline.arrowLeftDown,
                      label: "Recevoir",
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

// ── Widgets internes ──────────────────────────────────────────────────────────

class _ProfileAvatar extends StatelessWidget {
  final String initials;
  const _ProfileAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: KinoaColors.quinoaGold,
        boxShadow: [
          BoxShadow(
            color: KinoaColors.quinoaGold.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PeriodChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: KinoaColors.quinoaBlank,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: KinoaColors.quinoaSand),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: KinoaColors.quinoaWarmGray,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              SolarIconsOutline.altArrowDown,
              size: 12,
              color: KinoaColors.quinoaWarmGray,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final Color color;
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: KinoaColors.quinoaWarmGray,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${NumberFormat.compact(locale: "fr_FR").format(amount)} XAF",
              style: const TextStyle(
                color: KinoaColors.quinoaDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: KinoaColors.quinoaBlank,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: KinoaColors.quinoaSand),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: KinoaColors.quinoaDark),
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  color: KinoaColors.quinoaDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
