import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/staggered_entrance.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/application/bloc/send_state.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";

const List<String> _channels = ["MTN Mobile Money", "Airtel Money"];

/// Écran principal d'envoi : saisie → quote → confirmation → receipt.
class SendView extends StatefulWidget {
  const SendView({super.key});

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  final _recipientCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _sourceChannel = _channels[0];
  String _destChannel = _channels[1];

  @override
  void dispose() {
    _recipientCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _requestQuote() {
    final amount = double.tryParse(_amountCtrl.text.replaceAll(" ", ""));
    if (_recipientCtrl.text.trim().isEmpty || amount == null || amount <= 0) {
      AuthSnackBar.showError(context, "Veuillez remplir tous les champs.");
      return;
    }
    context.read<SendBloc>().add(SendQuoteRequested(
      recipientIdentifier: _recipientCtrl.text.trim(),
      amount: amount,
      sourceChannel: _sourceChannel,
      destinationChannel: _destChannel,
    ));
  }

  void _onState(BuildContext ctx, SendState state) {
    if (state is SendSuccess) {
      Navigator.pushNamed(ctx, KinoaRoutes.receipt, arguments: state.transaction);
      context.read<SendBloc>().add(SendReset());
      _recipientCtrl.clear();
      _amountCtrl.clear();
    } else if (state is SendError) {
      AuthSnackBar.showError(ctx, state.exception.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return BlocConsumer<SendBloc, SendState>(
      listener: _onState,
      builder: (context, state) {
        if (state is SendQuoteReady) return _buildConfirm(context, state.quote, topInset);
        if (state is SendConfirming) return _buildConfirming(topInset);
        return _buildForm(context, state, topInset);
      },
    );
  }

  Widget _buildForm(BuildContext context, SendState state, double topInset) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, topInset + 80, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KinoaEntrance(
            index: 0,
            child: Text(SendStrings.title, style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
          ),
          const SizedBox(height: 32),
          KinoaEntrance(index: 1, child: _buildField(SendStrings.recipientLabel, _recipientCtrl, "Numéro ou @identifiant", TextInputType.phone)),
          const SizedBox(height: 16),
          KinoaEntrance(index: 2, child: _buildField(SendStrings.amountLabel, _amountCtrl, "ex. 5000", TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly])),
          const SizedBox(height: 16),
          KinoaEntrance(index: 3, child: _buildChannelPicker("De", _sourceChannel, (v) => setState(() => _sourceChannel = v!))),
          const SizedBox(height: 12),
          KinoaEntrance(index: 4, child: _buildChannelPicker("Vers", _destChannel, (v) => setState(() => _destChannel = v!))),
          const SizedBox(height: 40),
          KinoaEntrance(index: 5, child: KinoaPrimaryButton(text: "Obtenir le devis", isLoading: state is SendLoading, onPressed: _requestQuote)),
        ],
      ),
    );
  }

  Widget _buildConfirm(BuildContext context, TransferQuote quote, double topInset) {
    final fmt = NumberFormat("#,###", "fr_FR");
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, topInset + 80, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KinoaEntrance(index: 0, child: const Text("Confirmer l'envoi", style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.5))),
          const SizedBox(height: 28),
          KinoaEntrance(index: 1, child: _infoCard([
            _infoRow("Destinataire", quote.recipientName),
            _infoRow("Montant", "${fmt.format(quote.amount)} ${quote.currency}"),
            _infoRow("De", quote.sourceChannel),
            _infoRow("Vers", quote.destinationChannel),
          ])),
          const SizedBox(height: 16),
          KinoaEntrance(index: 2, child: _infoCard([
            _infoRow("Frais KinoaPay", "${fmt.format(quote.kinoaFee)} ${quote.currency}"),
            _infoRow("Frais opérateur", "${fmt.format(quote.operatorFee)} ${quote.currency}"),
            _infoRow("Total débité", "${fmt.format(quote.amountDebited)} ${quote.currency}", bold: true),
          ])),
          const SizedBox(height: 32),
          KinoaEntrance(index: 3, child: KinoaPrimaryButton(text: SendStrings.confirmBtn, onPressed: () => context.read<SendBloc>().add(SendConfirmRequested(quote.quoteId)))),
          const SizedBox(height: 12),
          KinoaEntrance(index: 4, child: KinoaPrimaryButton(text: "Annuler", isSecondary: true, onPressed: () => context.read<SendBloc>().add(SendReset()))),
        ],
      ),
    );
  }

  Widget _buildConfirming(double topInset) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: KinoaColors.quinoaGold, strokeWidth: 2.5),
          const SizedBox(height: 20),
          Text("Envoi en cours…", style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.5), fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint, TextInputType type, {List<TextInputFormatter>? formatters}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(24), bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.45), fontSize: 12, fontWeight: FontWeight.w500)),
          TextField(
            controller: ctrl,
            keyboardType: type,
            inputFormatters: formatters,
            style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 16, fontWeight: FontWeight.w700),
            decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.2))),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelPicker(String label, String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.45), fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(Icons.expand_more_rounded, color: KinoaColors.quinoaDark.withValues(alpha: 0.4)),
                items: _channels.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.06)),
      ),
      child: Column(children: rows),
    );
  }

  Widget _infoRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.5), fontSize: 13)),
          Text(value, style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 14, fontWeight: bold ? FontWeight.w900 : FontWeight.w700)),
        ],
      ),
    );
  }
}
