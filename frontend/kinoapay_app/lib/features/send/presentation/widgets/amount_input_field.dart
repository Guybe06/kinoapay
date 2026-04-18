import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Champ de saisie du montant avec suffixe XAF.
class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const AmountInputField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SendStrings.amountDisplayLabel,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.10),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                  ],
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: AppColors.quinoaDark,
                  ),
                  decoration: InputDecoration(
                    hintText: SendStrings.amountHint,
                    hintStyle: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.15),
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              Text(
                SendStrings.amountUnit,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.35),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
