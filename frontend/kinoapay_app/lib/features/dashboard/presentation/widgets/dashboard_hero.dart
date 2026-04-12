import "dart:ui";
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
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

          // Main Balance Card (Inspirée de l'image 3)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: KinoaColors.accent,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Solde actuel",
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    _GlassChipSmall(
                      onTap: onPeriodClick,
                      child: Text(
                        DateFormat("MMMM", "fr_FR").format(DateTime.now()),
                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      NumberFormat.currency(symbol: "", decimalDigits: 0, locale: "fr_FR").format(totalReceived).trim(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "XAF",
                      style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
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
            color: Colors.black.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w800),
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
          color: Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.black12),
        ),
        child: child,
      ),
    );
  }
}

class _HeroCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2D241C), Color(0xFF1A140F)],
      ).createShader(Offset.zero & size);

    final path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
    
    // Ajout d'un éclat subtil (Anode style)
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(Offset(size.width * 0.8, 100), 120, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlassChip extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassChip({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.white10),
            ),
            child: child,
          ),
        ),
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

class _MiniStat extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isCount;

  const _MiniStat({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.isCount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            isCount ? "${amount.toInt()} actifs" : "${NumberFormat.compact().format(amount)} FCFA",
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
