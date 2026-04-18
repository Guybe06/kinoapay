import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/send/infrastructure/source_accounts_mock.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipient_compact_card.dart";

/// Step 2 : montant en héros centré, sélecteurs de canal slim, pill destinataire.
class SendAmountStep extends StatefulWidget {
  final RecipientMatch recipient;
  final PaymentChannel? selectedSource;
  final PaymentChannel? selectedDest;
  final TextEditingController amountCtrl;
  final FocusNode amountFocus;
  final ValueChanged<PaymentChannel?> onSourceChanged;
  final ValueChanged<PaymentChannel?> onDestChanged;
  final VoidCallback onModifyRecipient;
  final VoidCallback onContinue;
  final ValueChanged<String> onExternalNameChanged;

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
    required this.onExternalNameChanged,
  });

  @override
  State<SendAmountStep> createState() => _SendAmountStepState();
}

class _SendAmountStepState extends State<SendAmountStep> {
  late final TextEditingController _externalNameCtrl;
  late final FocusNode _externalNameFocus;

  @override
  void initState() {
    super.initState();
    _externalNameCtrl = TextEditingController();
    _externalNameFocus = FocusNode();
    _externalNameCtrl.addListener(() {
      widget.onExternalNameChanged(_externalNameCtrl.text);
    });
  }

  @override
  void dispose() {
    _externalNameCtrl.dispose();
    _externalNameFocus.dispose();
    super.dispose();
  }

  bool get _channelsReady {
    if (widget.selectedSource == null) return false;
    if (widget.recipient.isKinoaUser && widget.recipient.channels.isNotEmpty) {
      return widget.selectedDest != null;
    }
    if (!widget.recipient.isKinoaUser) {
      return widget.selectedDest != null;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RecipientCompactCard(
          recipient: widget.recipient,
          onModify: widget.onModifyRecipient,
        ),
        const SizedBox(height: 36),
        if (!widget.recipient.isKinoaUser) ...[
          _buildExternalNameInput(),
          const SizedBox(height: 24),
        ],
        _buildChannelRow(context),
        if (_channelsReady) ...[
          const SizedBox(height: 48),
          _buildHeroAmount(),
          const SizedBox(height: 52),
          _buildContinueButton(),
        ],
      ],
    );
  }

  Widget _buildExternalNameInput() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stone200, width: 1),
      ),
      child: TextField(
        controller: _externalNameCtrl,
        focusNode: _externalNameFocus,
        style: const TextStyle(
          color: AppColors.quinoaDark,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: "Nom du destinataire",
          hintStyle: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.3),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildChannelRow(BuildContext context) {
    final hasDestChoice =
        widget.recipient.isKinoaUser && widget.recipient.channels.isNotEmpty;
    final isExternal = !widget.recipient.isKinoaUser;
    return Row(
      children: [
        Expanded(
          child: _ChannelSelector(
            label: SendStrings.sourceLabel,
            selected: widget.selectedSource,
            channels: SourceAccountsMock.list,
            onChanged: widget.onSourceChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            SolarIconsOutline.altArrowRight,
            size: 16,
            color: AppColors.quinoaDark.withValues(alpha: 0.3),
          ),
        ),
        Expanded(
          child: hasDestChoice
              ? _ChannelSelector(
                  label: SendStrings.destLabel,
                  selected: widget.selectedDest,
                  channels: widget.recipient.channels,
                  onChanged: widget.onDestChanged,
                )
              : isExternal
              ? _ChannelSelector(
                  label: SendStrings.destLabel,
                  selected: widget.selectedDest,
                  channels: SourceAccountsMock.list,
                  onChanged: widget.onDestChanged,
                )
              : _StaticChannelLabel(label: SendStrings.destLabel),
        ),
      ],
    );
  }

  Widget _buildHeroAmount() {
    return Column(
      children: [
        TextField(
          controller: widget.amountCtrl,
          focusNode: widget.amountFocus,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
            _AmountFormatter(),
          ],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 64,
            color: AppColors.quinoaDark,
            letterSpacing: -2,
            height: 1.1,
          ),
          decoration: InputDecoration(
            hintText: "0",
            hintStyle: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.12),
              fontWeight: FontWeight.w300,
              fontSize: 64,
              letterSpacing: -2,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          SendStrings.amountUnit,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.3),
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 3,
          ),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.amountCtrl,
          builder: (_, value, __) {
            final raw =
                double.tryParse(value.text.replaceAll(RegExp(r"[^\d]"), "")) ??
                0;
            if (raw <= 0) return const SizedBox(height: 16);
            final fees = (raw * 0.03).ceil();
            final fmt = NumberFormat("#,##0", "en_US");
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                SendStrings.feesEstimateLabel(fmt.format(fees)),
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.35),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: widget.onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.quinoaDark,
          foregroundColor: AppColors.quinoaCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
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

class _AmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final digits = newValue.text.replaceAll(RegExp(r"[^\d]"), "");
    if (digits.isEmpty) return TextEditingValue.empty;

    final number = int.parse(digits);
    final formatted = NumberFormat("#,##0", "en_US").format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Sélecteur de canal : pill cliquable qui ouvre une bottom sheet.
class _ChannelSelector extends StatelessWidget {
  final String label;
  final PaymentChannel? selected;
  final List<PaymentChannel> channels;
  final ValueChanged<PaymentChannel?> onChanged;

  const _ChannelSelector({
    required this.label,
    required this.selected,
    required this.channels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSheet(context),
      child: _ChannelPill(
        label: label,
        value: selected?.label ?? "—",
        showChevron: true,
      ),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.45),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 16),
              ...channels.map((ch) {
                final isSelected = ch == selected;
                return GestureDetector(
                  onTap: () {
                    onChanged(ch);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.quinoaDark.withValues(alpha: 0.06)
                          : AppColors.stone50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ch.label,
                                style: TextStyle(
                                  color: AppColors.quinoaDark,
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                              Text(
                                ch.value,
                                style: TextStyle(
                                  color: AppColors.quinoaDark.withValues(
                                    alpha: 0.4,
                                  ),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            SolarIconsOutline.checkCircle,
                            size: 18,
                            color: AppColors.quinoaGold,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pill non-interactive affichant un canal fixe (ex. destinataire externe).
class _StaticChannelLabel extends StatelessWidget {
  final String label;
  const _StaticChannelLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return _ChannelPill(
      label: label,
      value: SendStrings.externalUserTag,
      showChevron: false,
    );
  }
}

class _ChannelPill extends StatelessWidget {
  final String label;
  final String value;
  final bool showChevron;

  const _ChannelPill({
    required this.label,
    required this.value,
    required this.showChevron,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.stone200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.quinoaDark.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.4),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showChevron)
                Icon(
                  SolarIconsOutline.altArrowDown,
                  size: 14,
                  color: AppColors.quinoaDark.withValues(alpha: 0.35),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
