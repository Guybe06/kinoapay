import "dart:ui";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

class SendView extends StatefulWidget {
  const SendView({super.key});

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  final TextEditingController _amountController = TextEditingController(text: "5000");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2), // Stone 100
      body: Stack(
        children: [
          // Éléments de design en arrière-plan (glows)
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC8964A).withValues(alpha: 0.08),
              ),
            ),
          ),
          
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leadingWidth: 70,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: _GlassIconButton(
                    icon: CupertinoIcons.chevron_left,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: _GlassIconButton(
                      icon: CupertinoIcons.search,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const Text(
                      "Envoyer\nde l'argent",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: KinoaColors.stone900,
                        height: 1.1,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // SECTION : DESTINATAIRE (Glass Card)
                    const _SectionLabel(label: "DESTINATAIRE"),
                    const SizedBox(height: 12),
                    _GlassCard(
                      child: Row(
                        children: [
                          _AvatarWithStatus(initials: "JD", color: const Color(0xFFC8964A)),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jean Dupont",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: KinoaColors.stone900,
                                  ),
                                ),
                                Text(
                                  "Orange Money • +225 07...",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: KinoaColors.stone500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(CupertinoIcons.chevron_down, size: 14, color: KinoaColors.stone400),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // SECTION : MONTANT (Gros bloc sombre inspiré par tes images)
                    const _SectionLabel(label: "MONTANT"),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A140F), // Ultra Dark
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A140F).withValues(alpha: 0.15),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              IntrinsicWidth(
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 64,
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: -3,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "FCFA",
                                style: TextStyle(
                                  color: Color(0xFFC8964A),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              "Frais : 0 FCFA (Kinoa Transfert)",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    // SECTION : CANAL (Horizontal Glass Selection)
                    const _SectionLabel(label: "CANAL DE PAIEMENT"),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        children: [
                          _ChannelCard(
                            name: "Wave",
                            balance: "45k",
                            icon: CupertinoIcons.wind,
                            color: Colors.blue.shade400,
                            isSelected: true,
                          ),
                          const SizedBox(width: 12),
                          _ChannelCard(
                            name: "OM",
                            balance: "120k",
                            icon: CupertinoIcons.flame_fill,
                            color: Colors.orange.shade700,
                            isSelected: false,
                          ),
                          const SizedBox(width: 12),
                          _ChannelCard(
                            name: "MoMo",
                            balance: "8k",
                            icon: CupertinoIcons.creditcard_fill,
                            color: Colors.yellow.shade700,
                            isSelected: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120), // Espace pour le bouton
                  ]),
                ),
              ),
            ],
          ),
          
          // BOUTON DE CONFIRMATION (Liquid Glass Design)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: _ActionConfirmButton(
              onTap: () {},
              label: "Confirmer l'envoi",
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: KinoaColors.stone400,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: Icon(icon, size: 20, color: KinoaColors.stone900),
      ),
    );
  }
}

class _AvatarWithStatus extends StatelessWidget {
  final String initials;
  final Color color;
  const _AvatarWithStatus({required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChannelCard extends StatelessWidget {
  final String name;
  final String balance;
  final IconData icon;
  final Color color;
  final bool isSelected;

  const _ChannelCard({
    required this.name,
    required this.balance,
    required this.icon,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1A140F) : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.white,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFFC8964A) : color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: isSelected ? Colors.white : KinoaColors.stone900,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                balance,
                style: TextStyle(
                  color: isSelected ? Colors.white54 : KinoaColors.stone500,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ActionConfirmButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionConfirmButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC8964A).withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Material(
          color: const Color(0xFFC8964A),
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
