import "dart:ui";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/onboarding/domain/onboarding_strings.dart";
import "package:kinoapay_app/features/onboarding/presentation/payment_setup/payment_setup_channel_models.dart";

/// Feuille modale : sélection du canal puis saisie du numéro.
class PaymentSetupLinkSheet extends StatefulWidget {
  final String suggestedPhone;
  final String suggestedCountryCode;
  final void Function(
    PaymentSetupChannelDef channel,
    String phone,
    String countryCode,
  )
  onConfirm;

  const PaymentSetupLinkSheet({
    super.key,
    required this.suggestedPhone,
    required this.suggestedCountryCode,
    required this.onConfirm,
  });

  @override
  State<PaymentSetupLinkSheet> createState() => _PaymentSetupLinkSheetState();
}

class _PaymentSetupLinkSheetState extends State<PaymentSetupLinkSheet> {
  late final TextEditingController _phoneCtrl;
  PaymentSetupChannelDef? _selected;

  @override
  void initState() {
    super.initState();
    _phoneCtrl = TextEditingController(text: widget.suggestedPhone);
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(
                color: AppColors.quinoaDark.withValues(alpha: 0.06),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandle(),
              const SizedBox(height: 24),
              _buildChannelSelector(),
              const SizedBox(height: 24),
              _buildPhoneField(),
              const SizedBox(height: 28),
              PrimaryButton(
                text: OnboardingStrings.paymentSetupConfirm,
                onPressed: _confirm,
                enabled: _canConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildChannelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingStrings.paymentSetupSelectChannel,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.45),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: paymentSetupChannels.map((ch) {
            final selected = _selected?.type == ch.type;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selected = ch),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    right: ch != paymentSetupChannels.last ? 12 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: selected
                        ? ch.color.withValues(alpha: 0.10)
                        : AppColors.quinoaCream,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? ch.color.withValues(alpha: 0.5)
                          : AppColors.quinoaDark.withValues(alpha: 0.08),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: ch.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          ch.shortLabel,
                          style: TextStyle(
                            color: ch.textColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ch.label,
                        style: const TextStyle(
                          color: AppColors.quinoaDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingStrings.paymentSetupPhoneLabel,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.45),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.quinoaCream,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Text(
                  widget.suggestedCountryCode,
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 22,
                color: AppColors.quinoaDark.withValues(alpha: 0.1),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    hintText: OnboardingStrings.paymentSetupPhoneHint,
                    hintStyle: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.25),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          OnboardingStrings.paymentSetupPhoneNote,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.35),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  bool get _canConfirm =>
      _selected != null &&
      _phoneCtrl.text.trim().replaceAll(" ", "").isNotEmpty;

  void _confirm() {
    final phone = _phoneCtrl.text.trim().replaceAll(" ", "");
    widget.onConfirm(_selected!, phone, widget.suggestedCountryCode);
    Navigator.pop(context);
  }
}
