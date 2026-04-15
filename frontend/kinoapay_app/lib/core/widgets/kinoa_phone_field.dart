import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";
import "package:kinoapay_app/core/widgets/country_picker_sheet.dart";

/// Formate les chiffres saisis en groupes 2 + 3 + 2×n pour l'affichage du numéro.
class _PhoneGroupFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll(RegExp(r"\D"), "");
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5 || (i > 5 && (i - 5) % 2 == 0)) buffer.write(" ");
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Champ de saisie du numéro de téléphone avec sélecteur de code pays intégré.
class KinoaPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onCountryChanged;
  final String? Function(String?)? validator;
  final CountryEntry? initialCountry;

  const KinoaPhoneField({
    super.key,
    required this.controller,
    required this.onCountryChanged,
    this.validator,
    this.initialCountry,
  });

  @override
  State<KinoaPhoneField> createState() => _KinoaPhoneFieldState();
}

class _KinoaPhoneFieldState extends State<KinoaPhoneField> {
  late CountryEntry _selected;
  final _focusNode = FocusNode();
  bool _hasFocus = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCountry ?? kinoaCountries[0];
    _focusNode.addListener(() => setState(() => _hasFocus = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _openPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CountryPickerSheet(
        selected: _selected,
        onSelected: (c) {
          setState(() => _selected = c);
          widget.onCountryChanged(c.dialCode);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topRight: Radius.circular(24),
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    );

    final ringColor = _hasError
        ? KinoaColors.quinoaRed.withValues(alpha: 0.12)
        : KinoaColors.quinoaGold.withValues(alpha: 0.14);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: (_hasFocus || _hasError) ? ringColor : Colors.transparent,
            spreadRadius: 3,
            blurRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.phone,
        inputFormatters: [_PhoneGroupFormatter()],
        onChanged: (_) { if (_hasError) setState(() => _hasError = false); },
        validator: (value) {
          final result = widget.validator?.call(value);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _hasError != (result != null)) {
              setState(() => _hasError = result != null);
            }
          });
          return result;
        },
        style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 16, fontWeight: FontWeight.w600),
        cursorColor: KinoaColors.quinoaGold,
        decoration: InputDecoration(
          labelText: KinoaStrings.phoneFieldLabel,
          labelStyle: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.45), fontSize: 14, fontWeight: FontWeight.w500),
          hintText: KinoaStrings.phoneFieldHint,
          hintStyle: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.25), fontSize: 14),
          floatingLabelStyle: const TextStyle(color: KinoaColors.quinoaGold, fontWeight: FontWeight.w700),
          contentPadding: const EdgeInsets.only(right: 24, top: 22, bottom: 22),
          prefixIcon: GestureDetector(
            onTap: _openPicker,
            child: Container(
              margin: const EdgeInsets.only(left: 4, right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: KinoaColors.quinoaDark.withValues(alpha: 0.12), width: 1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selected.flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text(_selected.dialCode, style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down_rounded, color: KinoaColors.quinoaDark.withValues(alpha: 0.4), size: 18),
                ],
              ),
            ),
          ),
          filled: true,
          fillColor: _hasFocus ? KinoaColors.white : KinoaColors.white.withValues(alpha: 0.65),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: KinoaColors.quinoaDark.withValues(alpha: 0.12), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: KinoaColors.quinoaGold.withValues(alpha: 0.6), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: KinoaColors.quinoaRed.withValues(alpha: 0.35), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: KinoaColors.quinoaRed.withValues(alpha: 0.6), width: 1.5),
          ),
          errorStyle: const TextStyle(color: KinoaColors.quinoaRed, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
