import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/utils/amount_formatter.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";
import "package:kinoapay_app/core/widgets/staggered_entrance.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";

/// Écran reçu de transaction : détail complet + partage.
class ReceiptView extends StatefulWidget {
  const ReceiptView({super.key});

  @override
  State<ReceiptView> createState() => _ReceiptViewState();
}

class _ReceiptViewState extends State<ReceiptView> {
  final _scrollController = ScrollController();
  bool _headerVisible = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;

    // Si on est en haut de la page (ou en overscroll), on force le header visible
    if (offset <= 0) {
      if (!_headerVisible) setState(() => _headerVisible = true);
      _lastOffset = offset;
      return;
    }

    final delta = offset - _lastOffset;
    _lastOffset = offset;

    // Réaction immédiate sans délai d'offset
    if (delta > 4 && _headerVisible) {
      setState(() => _headerVisible = false);
    } else if (delta < -4 && !_headerVisible) {
      setState(() => _headerVisible = true);
    }
  }

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
        body: Stack(
          children: [
            // Contenu principal
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
                child: Column(
                  children: [
                    StaggeredEntrance(
                      index: 0,
                      child: _buildMainHeader(),
                    ),
                    const SizedBox(height: 32),
                    StaggeredEntrance(index: 1, child: _buildAmount(tx, isOutgoing)),
                    const SizedBox(height: 40),
                    StaggeredEntrance(index: 2, child: _buildDetailsCard(tx, isOutgoing)),
                    const SizedBox(height: 16),
                    StaggeredEntrance(index: 3, child: _buildFeesCard(tx)),
                    const SizedBox(height: 16),
                    StaggeredEntrance(index: 4, child: _buildRefCard(tx)),
                    const SizedBox(height: 40),
                    StaggeredEntrance(
                      index: 5,
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.quinoaDark,
                            foregroundColor: AppColors.quinoaCream,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Terminer",
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Header Flottant
            _buildFloatingHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingHeader() {
    final topInset = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: _headerVisible
          ? AppBackHeader(
              onBack: () => Navigator.pop(context),
              backLabel: "Retour",
              title: "Reçu",
              subtitle: "Détails de la transaction",
              trailing: const BrandLogoRow(
                size: BrandSize.sm,
                color: AppColors.quinoaDark,
                iconColor: AppColors.quinoaGold,
              ),
            )
          : SizedBox(height: topInset),
    );
  }

  Widget _buildMainHeader() {
    return const Column(
      children: [
        Text(
          "Transaction effectuée",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.quinoaDark,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Votre transfert a été traité avec succès",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0x661D2125), // quinoaDark with values alpha 0.4
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAmount(Transaction tx, bool isOutgoing) {
    final sign = isOutgoing ? "−" : "+";
    final color = isOutgoing ? AppColors.quinoaDark : AppColors.accentDark;
    return Column(
      children: [
        Text(
          "$sign ${AmountFormatter.withCurrency(tx.amount, tx.currency)}",
          style: TextStyle(
            color: color,
            fontSize: 56,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat("d MMMM yyyy à HH:mm", "fr_FR").format(tx.startedAt),
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
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
    return _Card(children: [
      _Row(label: "Montant envoyé", value: AmountFormatter.withCurrency(tx.fees.amountDebited, tx.currency)),
      _Row(label: "Frais kinoaPay", value: AmountFormatter.withCurrency(tx.fees.platformFee, tx.currency)),
      _Row(label: "Frais opérateur", value: AmountFormatter.withCurrency(tx.fees.sourceOperatorFee + tx.fees.destinationOperatorFee, tx.currency)),
      _Row(label: "Montant reçu", value: AmountFormatter.withCurrency(tx.fees.amountReceived, tx.currency), bold: true),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == children.length - 1 ? 0 : 16),
            child: children[index],
          );
        }),
      ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: bold ? 0.8 : 0.45),
              fontSize: 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: AppColors.quinoaDark,
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
