import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Étape de validation USSD pour confirmer le retrait des fonds via opérateur mobile.
class UssdValidationStep extends StatefulWidget {
  final VoidCallback onValidated;

  const UssdValidationStep({super.key, required this.onValidated});

  @override
  State<UssdValidationStep> createState() => _UssdValidationStepState();
}

class _UssdValidationStepState extends State<UssdValidationStep> {
  final TextEditingController _ussdCtrl = TextEditingController();
  final FocusNode _ussdFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), _ussdFocus.requestFocus);
  }

  @override
  void dispose() {
    _ussdCtrl.dispose();
    _ussdFocus.dispose();
    super.dispose();
  }

  void _handleValidate() {
    final code = _ussdCtrl.text.trim();
    if (code.isEmpty) return;
    widget.onValidated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      appBar: AppBar(
        backgroundColor: AppColors.quinoaCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Icon(
                SolarIconsOutline.shieldCheck,
                size: 64,
                color: AppColors.quinoaGold,
              ),
              const SizedBox(height: 32),
              const Text(
                SendStrings.ussdTitle,
                style: TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                SendStrings.ussdMessage,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.stone200, width: 1),
                ),
                child: TextField(
                  controller: _ussdCtrl,
                  focusNode: _ussdFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  style: const TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 4,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "••••••",
                    hintStyle: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.3),
                      fontSize: 18,
                      letterSpacing: 4,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleValidate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.quinoaDark,
                    foregroundColor: AppColors.quinoaCream,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    SendStrings.ussdValidateBtn,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
