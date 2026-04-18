import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipients_results_list.dart";

/// Codes pays CEMAC disponibles dans le sélecteur.
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

/// Vue recherche par numéro de téléphone.
/// Inclut un sélecteur de code pays, un champ numérique (recherche ≥ 4 chiffres),
/// les résultats, et l'option « Envoyer vers ce numéro » si aucun utilisateur trouvé.
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.quinoaDark.withValues(alpha: 0.10),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildCountrySelector(),
          Container(
            width: 1,
            height: 28,
            margin: const EdgeInsets.symmetric(horizontal: 10),
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
                _PhoneGroupFormatter(),
              ],
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              decoration: InputDecoration(
                hintText: SendStrings.phoneHint,
                hintStyle: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w500,
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
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.white,
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
              const SizedBox(width: 8),
              Text(
                c.dialCode,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                c.label,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.5),
                  fontSize: 12,
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
          const SizedBox(width: 4),
          Text(
            selectedCountry.dialCode,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            SolarIconsOutline.altArrowDown,
            size: 14,
            color: AppColors.quinoaDark.withValues(alpha: 0.4),
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
          border: Border.all(
            color: AppColors.quinoaDark.withValues(alpha: 0.06),
            width: 1,
          ),
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
                color: AppColors.textMuted,
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
                      color: AppColors.quinoaDark.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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
              fontWeight: FontWeight.w800,
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
        strokeWidth: 1.6,
        color: AppColors.quinoaDark.withValues(alpha: 0.5),
      ),
    );
  }
}

/// Formatte les chiffres en groupes 2+3+2+2 pour la lisibilité.
class _PhoneGroupFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue next,
  ) {
    final digits = next.text.replaceAll(RegExp(r"\D"), "");
    final formatted = _format(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _format(String digits) {
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
