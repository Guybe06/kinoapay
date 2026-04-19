import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/constants/supported_countries.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_screen_header.dart";
import "package:kinoapay_app/core/widgets/phone_field.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_args.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_birth_date_field.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_date_utils.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_step_indicator.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_text_field.dart";

/// Étape 1 de l’inscription : identité, date de naissance, téléphone.
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
  String _countryCode = SupportedCountries.all[0].dialCode;
  bool _navigating = false;

  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    final d = signupBirthDateDefault18YearsAgo();
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

  void _clampDayToValidRange() {
    final max = signupDaysInMonth(_selectedYear, _selectedMonth);
    if (_selectedDay > max) {
      setState(() => _selectedDay = max);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _navigating) return;
    _navigating = true;
    Navigator.pushNamed(
      context,
      AppRoutes.signupOtp,
      arguments: SignupStep1Args(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        phone: _phoneCtrl.text.replaceAll(" ", ""),
        countryCode: _countryCode,
        birthDate: "$_selectedYear-${_selectedMonth.toString().padLeft(2, "0")}-${_selectedDay.toString().padLeft(2, "0")}",
      ),
    ).then((_) => _navigating = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.quinoaCream,
        body: SafeArea(
          child: Column(
            children: [
              const AuthScreenHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
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
            const SignupStep1StepIndicator(),
            const SizedBox(height: 24),
            const Text(
              AuthStrings.signupStep1Title,
              style: TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                height: 1.0,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AuthStrings.signupStep1Subtitle,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.55),
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
            AuthTextField(
              controller: _firstNameCtrl,
              label: AuthStrings.firstNameLabel,
              hintText: AuthStrings.firstNameHint,
              validator: AuthValidator.validateName,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _lastNameCtrl,
              label: AuthStrings.lastNameLabel,
              hintText: AuthStrings.lastNameHint,
              validator: AuthValidator.validateName,
            ),
            const SizedBox(height: 20),
            SignupBirthDateField(
              formFieldKey: _birthDateFieldKey,
              selectedDay: _selectedDay,
              selectedMonth: _selectedMonth,
              selectedYear: _selectedYear,
              onDayChanged: (d) => setState(() => _selectedDay = d),
              onMonthChanged: (m) => setState(() {
                _selectedMonth = m;
                _clampDayToValidRange();
              }),
              onYearChanged: (y) => setState(() {
                _selectedYear = y;
                _clampDayToValidRange();
              }),
            ),
            const SizedBox(height: 20),
            PhoneField(
              controller: _phoneCtrl,
              onCountryChanged: (code) => setState(() => _countryCode = code),
              validator: AuthValidator.validatePhone,
            ),
            const SizedBox(height: 48),
            PrimaryButton(
              text: AuthStrings.submitBtn,
              onPressed: _submit,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
