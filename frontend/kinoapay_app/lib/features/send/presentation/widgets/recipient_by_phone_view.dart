import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipients_results_list.dart";

class CountryCode {
  final String isoCode;
  final String dialCode;
  final String label;

  const CountryCode({
    required this.isoCode,
    required this.dialCode,
    required this.label,
  });

}

/// Vue recherche par numéro de téléphone — input sans bordure, shadow, flag emoji.
class RecipientByPhoneView extends StatelessWidget {
  static const int minPhoneDigits = 4;

  static const List<CountryCode> countryCodes = [
    CountryCode(isoCode: "CG", dialCode: "+242", label: "Congo"),
    CountryCode(isoCode: "CM", dialCode: "+237", label: "Cameroun"),
    CountryCode(isoCode: "GA", dialCode: "+241", label: "Gabon"),
    CountryCode(isoCode: "TD", dialCode: "+235", label: "Tchad"),
    CountryCode(isoCode: "CF", dialCode: "+236", label: "RCA"),
    CountryCode(isoCode: "GQ", dialCode: "+240", label: "Guinée Éq."),
  ];

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool isLoading;
  final List<RecipientMatch> results;
  final ValueChanged<RecipientMatch> onSelect;
  final VoidCallback onSendExternal;
  final VoidCallback onOpenContacts;
  final CountryCode selectedCountry;
  final ValueChanged<CountryCode> onCountryChanged;

  const RecipientByPhoneView({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.isLoading,
    required this.results,
    required this.onSelect,
    required this.onSendExternal,
    required this.onOpenContacts,
    required this.selectedCountry,
    required this.onCountryChanged,
  });

  bool get _hasEnoughDigits {
    final digits = controller.text.replaceAll(RegExp(r"\D"), "");
    return digits.length >= minPhoneDigits;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputRow(),
        if (results.isNotEmpty) ...[
          const SizedBox(height: 16),
          RecipientsResultsList(recipients: results, onSelect: onSelect),
        ],
        if (results.isEmpty && _hasEnoughDigits && !isLoading) ...[
          const SizedBox(height: 16),
          _buildExternalOption(),
        ],
        const SizedBox(height: 24),
        _buildContactsButton(),
      ],
    );
  }

  Widget _buildInputRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stone200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.quinoaDark.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildCountrySelector(),
          Container(
            width: 1,
            height: 26,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: AppColors.quinoaDark.withValues(alpha: 0.08),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                const PhoneGroupFormatter(),
              ],
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              decoration: InputDecoration(
                hintText: SendStrings.phoneHint,
                hintStyle: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.25),
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffixIcon: isLoading ? _buildLoadingIndicator() : null,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountrySelector() {
    return PopupMenuButton<CountryCode>(
      onSelected: onCountryChanged,
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.white,
      elevation: 8,
      shadowColor: AppColors.quinoaDark.withValues(alpha: 0.12),
      itemBuilder: (_) => countryCodes.map((c) {
        return PopupMenuItem<CountryCode>(
          value: c,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                c.isoCode,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: AppColors.quinoaDark,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                c.dialCode,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.quinoaDark,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                c.label,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.45),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedCountry.isoCode,
            style: const TextStyle(
              color: AppColors.quinoaDark,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            selectedCountry.dialCode,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            SolarIconsOutline.altArrowDown,
            size: 13,
            color: AppColors.quinoaDark.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }

  Widget _buildExternalOption() {
    return GestureDetector(
      onTap: onSendExternal,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.quinoaDark.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.stone100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                SolarIconsOutline.phoneCallingRounded,
                color: AppColors.stone500,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SendStrings.notOnKinoaLabel,
                    style: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.55),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    SendStrings.sendExternalBtn,
                    style: TextStyle(
                      color: AppColors.quinoaGold,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              SolarIconsOutline.altArrowRight,
              color: AppColors.quinoaGold,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsButton() {
    return GestureDetector(
      onTap: onOpenContacts,
      child: const Row(
        children: [
          Icon(
            SolarIconsOutline.usersGroupRounded,
            color: AppColors.quinoaGold,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            SendStrings.contactsBtn,
            style: TextStyle(
              color: AppColors.quinoaGold,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 14,
      height: 14,
      child: CircularProgressIndicator(
        strokeWidth: 1.5,
        color: AppColors.quinoaDark.withValues(alpha: 0.4),
      ),
    );
  }
}

/// Formatte les chiffres en groupes 2+3+2+2 pour la lisibilité.
class PhoneGroupFormatter extends TextInputFormatter {
  const PhoneGroupFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue next,
  ) {
    final formatted = format(next.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Formate une chaîne (avec ou sans espaces) en groupes 2+3+2+2.
  /// Utilisable en dehors d'un champ de saisie (ex. injection programmatique).
  static String format(String raw) {
    final digits = raw.replaceAll(RegExp(r"\D"), "");
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5 || i == 7 || (i > 7 && (i - 7) % 2 == 0)) {
        buf.write(" ");
      }
      buf.write(digits[i]);
    }
    return buf.toString();
  }
}
