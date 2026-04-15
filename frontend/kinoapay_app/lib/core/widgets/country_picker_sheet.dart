import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";

typedef CountryEntry = ({String iso, String flag, String name, String dialCode});

/// Pays pris en charge
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

/// Bottom sheet de sélection du code pays avec recherche intégrée.
class CountryPickerSheet extends StatefulWidget {
  final CountryEntry selected;
  final ValueChanged<CountryEntry> onSelected;

  const CountryPickerSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  KinoaStrings.countryPickerTitle,
                  style: TextStyle(
                    color: KinoaColors.quinoaDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
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
                  hintText: KinoaStrings.countryPickerSearchHint,
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
                    title: Text(
                      c.name,
                      style: TextStyle(
                        color: KinoaColors.quinoaDark,
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      c.dialCode,
                      style: const TextStyle(color: KinoaColors.quinoaWarmGray, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
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
