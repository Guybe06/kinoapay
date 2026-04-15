import "dart:ui";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/onboarding/payment_setup_channel_models.dart";

/// Feuille modale pour saisir le numéro lié au canal choisi.
class PaymentSetupLinkSheet extends StatefulWidget {
  final PaymentSetupChannelDef channel;
  final String suggestedPhone;
  final String suggestedCountryCode;
  final void Function(String phone, String countryCode) onConfirm;

  const PaymentSetupLinkSheet({
    super.key,
    required this.channel,
    required this.suggestedPhone,
    required this.suggestedCountryCode,
    required this.onConfirm,
  });

  @override
  State<PaymentSetupLinkSheet> createState() => _PaymentSetupLinkSheetState();
}

class _PaymentSetupLinkSheetState extends State<PaymentSetupLinkSheet> {
  late final TextEditingController _phoneCtrl;

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
            color: AppColors.surfaceCard,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.channel.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.channel.shortLabel,
                      style: TextStyle(
                        color: widget.channel.textColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    widget.channel.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Numéro de téléphone",
                style: TextStyle(
                  color: AppColors.stone400,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text(
                        widget.suggestedCountryCode,
                        style: const TextStyle(
                          color: AppColors.stone400,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(width: 1, height: 22, color: Colors.white12),
                    Expanded(
                      child: TextField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          hintText: "06 XXX XX XX",
                          hintStyle: TextStyle(color: AppColors.stone500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Utilisez le numéro enregistré sur ce réseau.",
                style: TextStyle(color: AppColors.stone500, fontSize: 11),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                text: AuthStrings.paymentSetupConfirm,
                onPressed: () {
                  final phone = _phoneCtrl.text.trim().replaceAll(" ", "");
                  if (phone.isNotEmpty) {
                    widget.onConfirm(phone, widget.suggestedCountryCode);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
