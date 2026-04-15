import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";
import "package:kinoapay_app/core/widgets/staggered_entrance.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";


/// Écran reçu de transaction : détail complet + partage.
class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    final tx = ModalRoute.of(context)!.settings.arguments as Transaction;
    final isOutgoing = tx.direction == "outgoing";
    final statusColor = tx.status == "success" ? AppColors.accentDark : AppColors.quinoaGold;
    final statusLabel = tx.status == "success" ? AppStrings.statusSuccess : AppStrings.statusPending;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.quinoaCream,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      StaggeredEntrance(index: 0, child: _buildStatusBadge(statusLabel, statusColor)),
                      const SizedBox(height: 20),
                      StaggeredEntrance(index: 1, child: _buildAmount(tx, isOutgoing)),
                      const SizedBox(height: 28),
                      StaggeredEntrance(index: 2, child: _buildDetailsCard(tx, isOutgoing)),
                      const SizedBox(height: 16),
                      StaggeredEntrance(index: 3, child: _buildFeesCard(tx)),
                      const SizedBox(height: 16),
                      StaggeredEntrance(index: 4, child: _buildRefCard(tx)),
                      const SizedBox(height: 32),
                      StaggeredEntrance(index: 5, child: PrimaryButton(text: "Fermer", onPressed: () => Navigator.pop(context))),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(SolarIconsOutline.altArrowLeft, color: AppColors.quinoaDark),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const BrandLogoRow(size: BrandSize.sm, color: AppColors.quinoaDark, iconColor: AppColors.quinoaGold),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildAmount(Transaction tx, bool isOutgoing) {
    final sign = isOutgoing ? "−" : "+";
    final color = isOutgoing ? AppColors.quinoaDark : AppColors.accentDark;
    return Column(
      children: [
        Text(
          "$sign ${NumberFormat("#,###", "fr_FR").format(tx.amount)} ${tx.currency}",
          style: TextStyle(color: color, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.5),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat("d MMMM yyyy à HH:mm", "fr_FR").format(tx.startedAt),
          style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.4), fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(Transaction tx, bool isOutgoing) {
    return _Card(children: [
      _Row(label: isOutgoing ? "Envoyé à" : "Reçu de", value: tx.receiverName ?? tx.receiverIdentifier),
      _Row(label: "De", value: tx.sourceChannel),
      _Row(label: "Vers", value: tx.destinationChannel),
    ]);
  }

  Widget _buildFeesCard(Transaction tx) {
    final fmt = NumberFormat("#,###", "fr_FR");
    return _Card(children: [
      _Row(label: "Montant envoyé", value: "${fmt.format(tx.fees.amountDebited)} ${tx.currency}"),
      _Row(label: "Frais kinoaPay", value: "${fmt.format(tx.fees.platformFee)} ${tx.currency}"),
      _Row(label: "Frais opérateur", value: "${fmt.format(tx.fees.sourceOperatorFee + tx.fees.destinationOperatorFee)} ${tx.currency}"),
      _Row(label: "Montant reçu", value: "${fmt.format(tx.fees.amountReceived)} ${tx.currency}", bold: true),
    ]);
  }

  Widget _buildRefCard(Transaction tx) {
    return _Card(children: [
      _Row(label: "Référence", value: tx.transactionId),
    ]);
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
      ),
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _Row({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.5), fontSize: 13, fontWeight: FontWeight.w500))),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: AppColors.quinoaDark, fontSize: 14, fontWeight: bold ? FontWeight.w900 : FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
