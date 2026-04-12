import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

typedef CountryEntry = ({String iso, String flag, String name, String dialCode});

/// Pays d'Afrique centrale pris en charge (CEMAC + RDC + Angola).
const List<CountryEntry> kinoaCountries = [
  (iso: "CG", flag: "🇨🇬", name: "Congo-Brazzaville", dialCode: "+242"),
  (iso: "CD", flag: "🇨🇩", name: "Congo-Kinshasa", dialCode: "+243"),
  (iso: "GA", flag: "🇬🇦", name: "Gabon", dialCode: "+241"),
  (iso: "CM", flag: "🇨🇲", name: "Cameroun", dialCode: "+237"),
  (iso: "CF", flag: "🇨🇫", name: "Centrafrique", dialCode: "+236"),
  (iso: "TD", flag: "🇹🇩", name: "Tchad", dialCode: "+235"),
  (iso: "GQ", flag: "🇬🇶", name: "Guinée Équatoriale", dialCode: "+240"),
  (iso: "AO", flag: "🇦🇴", name: "Angola", dialCode: "+244"),
];

/// Formate le numéro : XX XXX XX XX XX…
/// Groupes : 2 chiffres, puis 3 chiffres, puis 2 chiffres répétés.
class _PhoneGroupFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll(RegExp(r"\D"), "");
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      // Espace avant position 2 (groupe 2→3), position 5 (groupe 3→2), puis toutes les 2.
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
      builder: (_) => _CountryPickerSheet(
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
          labelText: "Numéro de téléphone",
          labelStyle: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.45), fontSize: 14, fontWeight: FontWeight.w500),
          hintText: "06 000 00 00",
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
                  Text(
                    _selected.dialCode,
                    style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
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

/// Bottom sheet de sélection du code pays avec recherche intégrée.
class _CountryPickerSheet extends StatefulWidget {
  final CountryEntry selected;
  final ValueChanged<CountryEntry> onSelected;

  const _CountryPickerSheet({required this.selected, required this.onSelected});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _search = TextEditingController();
  List<CountryEntry> _filtered = kinoaCountries;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    final lower = q.toLowerCase();
    setState(() {
      _filtered = kinoaCountries
          .where((c) => c.name.toLowerCase().contains(lower) || c.dialCode.contains(lower))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      snap: true,
      snapSizes: const [0.65, 0.92],
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: KinoaColors.quinoaCream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: KinoaColors.quinoaDark.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Choisir un pays",
                style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _search,
                onChanged: _onSearch,
                style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 15),
                cursorColor: KinoaColors.quinoaGold,
                decoration: InputDecoration(
                  hintText: "Rechercher un pays...",
                  hintStyle: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.3), fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded, color: KinoaColors.quinoaDark.withValues(alpha: 0.35), size: 20),
                  filled: true,
                  fillColor: KinoaColors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: KinoaColors.quinoaDark.withValues(alpha: 0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: KinoaColors.quinoaDark.withValues(alpha: 0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: KinoaColors.quinoaGold.withValues(alpha: 0.6), width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final c = _filtered[i];
                  final isSelected = c.iso == widget.selected.iso;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                    title: Text(c.name, style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 15, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
                    trailing: Text(c.dialCode, style: TextStyle(color: KinoaColors.quinoaWarmGray, fontSize: 14, fontWeight: FontWeight.w600)),
                    selected: isSelected,
                    selectedTileColor: KinoaColors.quinoaGold.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: () {
                      widget.onSelected(c);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
