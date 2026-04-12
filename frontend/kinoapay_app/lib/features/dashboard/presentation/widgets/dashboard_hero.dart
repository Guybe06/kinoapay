import "package:flutter/material.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:intl/intl.dart";

/// Section Hero du tableau de bord affichant le solde et les statistiques.
class DashboardHero extends StatelessWidget {
  final String displayName;
  final double totalSent;
  final double totalReceived;
  final List<PaymentChannel> channels;
  final VoidCallback onPeriodClick;

  const DashboardHero({
    super.key,
    required this.displayName,
    required this.totalSent,
    required this.totalReceived,
    required this.channels,
    required this.onPeriodClick,
  });

  @override
  Widget build(BuildContext context) {
    final String initials = displayName.isNotEmpty
        ? displayName.split(" ").map((n) => n[0]).take(2).join("").toUpperCase()
        : "?";

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1C1410),
            Color(0xFF2C2416),
            Color(0xFF3D3428),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bonjour,",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    color: KinoaColors.stone600,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: onPeriodClick,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat("MMMM yyyy", "fr_FR").format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      LucideIcons.chevronDown,
                      size: 13,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: "REÇU",
                    amount: totalReceived,
                    icon: LucideIcons.trendingDown,
                    isMain: true,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: _StatItem(
                      label: "ENVOYÉ",
                      amount: totalSent,
                      icon: LucideIcons.trendingUp,
                      isMain: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ChannelsList(channels: channels),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final bool isMain;

  const _StatItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.isMain,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: "FCFA", decimalDigits: 0, locale: "fr_FR");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.white.withValues(alpha: 0.4)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          formatter.format(amount).replaceAll("FCFA", "").trim(),
          style: TextStyle(
            color: isMain ? Colors.white : Colors.white.withValues(alpha: 0.7),
            fontSize: isMain ? 30 : 14,
            fontWeight: isMain ? FontWeight.w400 : FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class _ChannelsList extends StatelessWidget {
  final List<PaymentChannel> channels;

  const _ChannelsList({required this.channels});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: channels.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == channels.length) {
            return _AddChannelButton();
          }
          return _ChannelCard(channel: channels[index]);
        },
      ),
    );
  }
}

class _ChannelCard extends StatelessWidget {
  final PaymentChannel channel;

  const _ChannelCard({required this.channel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          _getChannelIcon(channel.short),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                channel.short,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                channel.value,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getChannelIcon(String short) {
    Color bgColor = Colors.grey;
    if (short.toUpperCase() == "MTN") bgColor = const Color(0xFFFFCC00);
    if (short.toUpperCase() == "AIRTEL") bgColor = const Color(0xFFFF0000);

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          short[0],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _AddChannelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), style: BorderStyle.none),
      ),
      child: const Icon(LucideIcons.plus, color: Colors.white, size: 20),
    );
  }
}
