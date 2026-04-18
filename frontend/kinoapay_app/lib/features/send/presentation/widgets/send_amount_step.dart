import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/send/infrastructure/source_accounts_mock.dart";
import "package:kinoapay_app/features/send/presentation/widgets/amount_input_field.dart";
import "package:kinoapay_app/features/send/presentation/widgets/channel_dropdown.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipient_compact_card.dart";

/// Step 2 du flux d'envoi : carte destinataire, sélection canaux, montant, bouton continuer.
class SendAmountStep extends StatelessWidget {
  final RecipientMatch recipient;
  final PaymentChannel? selectedSource;
  final PaymentChannel? selectedDest;
  final TextEditingController amountCtrl;
  final FocusNode amountFocus;
  final ValueChanged<PaymentChannel?> onSourceChanged;
  final ValueChanged<PaymentChannel?> onDestChanged;
  final VoidCallback onModifyRecipient;
  final VoidCallback onContinue;

  const SendAmountStep({
    super.key,
    required this.recipient,
    required this.selectedSource,
    required this.selectedDest,
    required this.amountCtrl,
    required this.amountFocus,
    required this.onSourceChanged,
    required this.onDestChanged,
    required this.onModifyRecipient,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecipientCompactCard(
          recipient: recipient,
          onModify: onModifyRecipient,
        ),
        const SizedBox(height: 20),
        ChannelDropdown(
          label: SendStrings.sourceLabel,
          channels: SourceAccountsMock.list,
          selected: selectedSource,
          onChanged: onSourceChanged,
        ),
        if (recipient.isKinoaUser && recipient.channels.isNotEmpty) ...[
          const SizedBox(height: 16),
          ChannelDropdown(
            label: SendStrings.destLabel,
            channels: recipient.channels,
            selected: selectedDest,
            onChanged: onDestChanged,
          ),
        ],
        const SizedBox(height: 24),
        AmountInputField(
          controller: amountCtrl,
          focusNode: amountFocus,
        ),
        const SizedBox(height: 32),
        _buildContinueButton(),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.quinoaDark,
          foregroundColor: AppColors.quinoaCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          SendStrings.continueBtn,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }
}
