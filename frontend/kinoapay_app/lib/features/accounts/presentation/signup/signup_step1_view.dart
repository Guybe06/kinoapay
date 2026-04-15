import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";
import "package:kinoapay_app/core/widgets/country_picker_sheet.dart";
import "package:kinoapay_app/core/widgets/phone_field.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_text_field.dart";
import "package:kinoapay_app/core/widgets/staggered_entrance.dart";

/// Noms des mois en français (index 0 = janvier).
const List<String> _kMonthNamesFr = [
  "Janvier",
  "Février",
  "Mars",
  "Avril",
  "Mai",
  "Juin",
  "Juillet",
  "Août",
  "Septembre",
  "Octobre",
  "Novembre",
  "Décembre",
];

/// Nombre de jours dans [month] (1–12) pour [year] (bissextile géré).
int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

/// Année la plus récente autorisée (âge minimum 18 ans).
int _maxBirthYear() => DateTime.now().year - 18;

/// Année la plus ancienne autorisée (âge max 115 ans).
int _minBirthYear() => DateTime.now().year - 115;

/// Années du select : de la plus récente à la plus ancienne.
List<int> _yearOptions() {
  final minY = _minBirthYear();
  final maxY = _maxBirthYear();
  return List.generate(maxY - minY + 1, (i) => maxY - i);
}

/// Date du jour il y a exactement 18 ans (même jour / mois qu’aujourd’hui).
DateTime _birthDateDefault18YearsAgo() {
  final n = DateTime.now();
  return DateTime(n.year - 18, n.month, n.day);
}

/// Étape 1 de l'inscription : prénom, nom, date de naissance, numéro de téléphone.
class SignUpStep1View extends StatefulWidget {
  const SignUpStep1View({super.key});

  @override
  State<SignUpStep1View> createState() => _SignUpStep1ViewState();
}

class _SignUpStep1ViewState extends State<SignUpStep1View> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _birthDateFieldKey = GlobalKey<FormFieldState<void>>();
  String _countryCode = kinoaCountries[0].dialCode;
  bool _navigating = false;

  /// Valeurs par défaut dès la construction : évite [LateError] au hot reload ([initState] ne rejoue pas).
  int _selectedDay = _birthDateDefault18YearsAgo().day;
  int _selectedMonth = _birthDateDefault18YearsAgo().month;
  int _selectedYear = _birthDateDefault18YearsAgo().year;

  @override
  void initState() {
    super.initState();
    final d = _birthDateDefault18YearsAgo();
    _selectedDay = d.day;
    _selectedMonth = d.month;
    _selectedYear = d.year;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  /// Ajuste le jour si le mois / l’année ne permettent plus ce jour (ex. 31 → février).
  void _clampDayToValidRange() {
    final max = _daysInMonth(_selectedYear, _selectedMonth);
    if (_selectedDay > max) {
      _selectedDay = max;
    }
  }

  static const BorderRadius _fieldRadius = BorderRadius.only(
    topRight: Radius.circular(24),
    bottomLeft: Radius.circular(24),
    bottomRight: Radius.circular(24),
  );

  void _submit() {
    if (!_formKey.currentState!.validate() || _navigating) return;
    _navigating = true;
    final y = _selectedYear;
    final m = _selectedMonth;
    final d = _selectedDay;
    Navigator.pushNamed(
      context,
      KinoaRoutes.signupOtp,
      arguments: SignupStep1Args(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        phone: _phoneCtrl.text.replaceAll(" ", ""),
        countryCode: _countryCode,
        birthDate: "$y-${m.toString().padLeft(2, "0")}-${d.toString().padLeft(2, "0")}",
      ),
    ).then((_) => _navigating = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: KinoaColors.quinoaCream,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(SolarIconsOutline.altArrowLeft, color: KinoaColors.quinoaDark),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const KinoaBrand(size: BrandSize.sm, color: KinoaColors.quinoaDark, iconColor: KinoaColors.quinoaGold),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            KinoaEntrance(index: 0, child: _buildStepIndicator()),
            const SizedBox(height: 24),
            KinoaEntrance(
              index: 1,
              child: const Text(
                AuthStrings.signupStep1Title,
                style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 42, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -2),
              ),
            ),
            const SizedBox(height: 12),
            KinoaEntrance(
              index: 2,
              child: Text(
                AuthStrings.signupStep1Subtitle,
                style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4),
              ),
            ),
            const SizedBox(height: 40),
            KinoaEntrance(
              index: 3,
              child: AuthTextField(controller: _firstNameCtrl, label: AuthStrings.firstNameLabel, hintText: "ex. Sofia", validator: AuthValidator.validateName),
            ),
            const SizedBox(height: 20),
            KinoaEntrance(
              index: 4,
              child: AuthTextField(controller: _lastNameCtrl, label: AuthStrings.lastNameLabel, hintText: "ex. Mendes", validator: AuthValidator.validateName),
            ),
            const SizedBox(height: 20),
            KinoaEntrance(index: 5, child: _buildDateField()),
            const SizedBox(height: 20),
            KinoaEntrance(
              index: 6,
              child: KinoaPhoneField(controller: _phoneCtrl, onCountryChanged: (code) => setState(() => _countryCode = code), validator: AuthValidator.validatePhone),
            ),
            const SizedBox(height: 48),
            KinoaEntrance(index: 7, child: KinoaPrimaryButton(text: AuthStrings.submitBtn, onPressed: _submit)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _dot(active: true),
        const SizedBox(width: 6),
        _dot(active: false),
        const SizedBox(width: 10),
        Text(
          "Étape 1 sur 2",
          style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _dot({required bool active}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? KinoaColors.quinoaGold : KinoaColors.quinoaDark.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Jour / mois (libellés FR) / année dans un container unique style AuthTextField.
  Widget _buildDateField() {
    return FormField<void>(
      key: _birthDateFieldKey,
      validator: (_) => AuthValidator.validateBirthDateParts(
        _selectedDay.toString(),
        _selectedMonth.toString(),
        _selectedYear.toString(),
      ),
      builder: (state) {
        final maxDay = _daysInMonth(_selectedYear, _selectedMonth);
        final dayValues = List.generate(maxDay, (i) => i + 1);
        final years = _yearOptions();
        final borderColor = state.hasError
            ? KinoaColors.quinoaRed.withValues(alpha: 0.35)
            : KinoaColors.quinoaDark.withValues(alpha: 0.12);
        final dividerColor = KinoaColors.quinoaDark.withValues(alpha: 0.1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: KinoaColors.white.withValues(alpha: 0.65),
                borderRadius: _fieldRadius,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 12),
                    child: Text(
                      AuthStrings.birthDateLabel,
                      style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.45), fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _dateSegment(
                          value: _selectedDay,
                          items: dayValues.map((d) => DropdownMenuItem(value: d, child: Text("$d"))).toList(),
                          onChanged: (v) { setState(() { _selectedDay = v!; state.didChange(null); }); },
                        ),
                      ),
                      _verticalDivider(dividerColor),
                      Expanded(
                        flex: 4,
                        child: _dateSegment(
                          value: _selectedMonth,
                          items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(_kMonthNamesFr[i], overflow: TextOverflow.ellipsis))),
                          onChanged: (v) { setState(() { _selectedMonth = v!; _clampDayToValidRange(); state.didChange(null); }); },
                        ),
                      ),
                      _verticalDivider(dividerColor),
                      Expanded(
                        flex: 3,
                        child: _dateSegment(
                          value: _selectedYear,
                          items: years.map((y) => DropdownMenuItem(value: y, child: Text("$y"))).toList(),
                          onChanged: (v) { setState(() { _selectedYear = v!; _clampDayToValidRange(); state.didChange(null); }); },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 24),
                child: Text(state.errorText!, style: const TextStyle(color: KinoaColors.quinoaRed, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
          ],
        );
      },
    );
  }

  Widget _dateSegment({required int value, required List<DropdownMenuItem<int>> items, required ValueChanged<int?> onChanged}) {
    return DropdownButtonHideUnderline(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          menuMaxHeight: 320,
          icon: Icon(Icons.expand_more_rounded, size: 18, color: KinoaColors.quinoaDark.withValues(alpha: 0.35)),
          style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 16, fontWeight: FontWeight.w600),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _verticalDivider(Color color) {
    return Container(width: 1, height: 28, color: color);
  }
}

/// Données transmises de l'étape 1 vers l'étape 2 de l'inscription.
class SignupStep1Args {
  final String firstName;
  final String lastName;
  final String phone;
  final String countryCode;
  final String birthDate;

  const SignupStep1Args({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.countryCode,
    required this.birthDate,
  });
}
