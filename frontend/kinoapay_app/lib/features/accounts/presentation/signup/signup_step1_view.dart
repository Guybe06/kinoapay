import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";
import "package:kinoapay_app/core/widgets/kinoa_phone_field.dart";
import "package:kinoapay_app/core/widgets/kinoa_primary_button.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_text_field.dart";

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
  String _countryCode = kinoaCountries[0].dialCode;
  DateTime? _birthDate;
  String _birthDateDisplay = "";

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      locale: const Locale("fr"),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: KinoaColors.quinoaDark,
            onPrimary: KinoaColors.white,
            onSurface: KinoaColors.quinoaDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateDisplay = "${picked.day.toString().padLeft(2, "0")}/${picked.month.toString().padLeft(2, "0")}/${picked.year}";
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner votre date de naissance.")),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      KinoaRoutes.signupCredentials,
      arguments: SignupStep1Args(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        phone: _phoneCtrl.text.replaceAll(" ", ""),
        countryCode: _countryCode,
        birthDate: "${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, "0")}-${_birthDate!.day.toString().padLeft(2, "0")}",
      ),
    );
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
            icon: const Icon(LucideIcons.arrowLeft, color: KinoaColors.quinoaDark),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            _buildStepIndicator(),
            const SizedBox(height: 24),
            const Text(
              AuthStrings.signupStep1Title,
              style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 42, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -2),
            ),
            const SizedBox(height: 12),
            Text(
              AuthStrings.signupStep1Subtitle,
              style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 40),
            AuthTextField(
              controller: _firstNameCtrl,
              label: AuthStrings.firstNameLabel,
              hintText: "Jean",
              validator: AuthValidator.validateName,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _lastNameCtrl,
              label: AuthStrings.lastNameLabel,
              hintText: "Kimboula",
              validator: AuthValidator.validateName,
            ),
            const SizedBox(height: 20),
            _buildDateField(),
            const SizedBox(height: 20),
            KinoaPhoneField(
              controller: _phoneCtrl,
              onCountryChanged: (code) => setState(() => _countryCode = code),
              validator: AuthValidator.validatePhone,
            ),
            const SizedBox(height: 48),
            KinoaPrimaryButton(text: AuthStrings.submitBtn, onPressed: _submit),
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

  Widget _buildDateField() {
    const borderRadius = BorderRadius.only(
      topRight: Radius.circular(24),
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    );

    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        decoration: BoxDecoration(
          color: KinoaColors.white.withValues(alpha: 0.65),
          borderRadius: borderRadius,
          border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.12), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AuthStrings.birthDateLabel,
              style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.45), fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            _birthDateDisplay.isEmpty
                ? Text(
                    AuthStrings.birthDateHint,
                    style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.25), fontSize: 14),
                  )
                : Text(
                    _birthDateDisplay,
                    style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ],
        ),
      ),
    );
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
