import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_screen_header.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/presentation/forgot_password/forgot_password_args.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_text_field.dart";
import "package:kinoapay_app/core/constants/supported_countries.dart";
import "package:kinoapay_app/core/widgets/phone_field.dart";

/// Écran 1 : choix du canal (email / téléphone) et saisie du contact.
class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _contactCtrl = TextEditingController();
  bool _isEmail = true;
  String _countryCode = SupportedCountries.all[0].dialCode;
  bool _navigating = false;

  @override
  void dispose() {
    _contactCtrl.dispose();
    super.dispose();
  }

  String get _fullContact => _isEmail
      ? _contactCtrl.text.trim()
      : "$_countryCode${_contactCtrl.text.replaceAll(" ", "")}";

  void _onState(BuildContext ctx, AuthState state) {
    if (state is ResetOtpSent) {
      if (_navigating) return;
      _navigating = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) { _navigating = false; return; }
        Navigator.pushNamed(
          context,
          AppRoutes.forgotPasswordOtp,
          arguments: ForgotPasswordArgs(contact: _fullContact, isEmail: _isEmail),
        ).then((_) => _navigating = false);
      });
    } else if (state is AuthError) {
      AuthSnackBar.showError(ctx, state.exception.message);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      RequestPasswordResetRequested(contact: _fullContact, isEmail: _isEmail),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.quinoaCream,
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: _onState,
            builder: (context, state) => Column(
              children: [
                const AuthScreenHeader(),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AuthState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              AuthStrings.resetTitle,
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
              AuthStrings.resetSubtitle,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.55),
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            _buildChannelToggle(),
            const SizedBox(height: 28),
            _isEmail
                ? AuthTextField(
                    controller: _contactCtrl,
                    label: AuthStrings.emailLabel,
                    hintText: AuthStrings.resetEmailHint,
                    keyboardType: TextInputType.emailAddress,
                    validator: AuthValidator.validateEmailOrPhone,
                  )
                : PhoneField(
                    controller: _contactCtrl,
                    onCountryChanged: (code) =>
                        setState(() => _countryCode = code),
                    validator: AuthValidator.validatePhone,
                  ),
            const SizedBox(height: 48),
            PrimaryButton(
              text: AuthStrings.resetSendCode,
              isLoading: state is AuthLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelToggle() {
    return Row(
      children: [
        Text(
          AuthStrings.resetViaPhone,
          style: TextStyle(
            color: !_isEmail
                ? AppColors.quinoaDark
                : AppColors.quinoaDark.withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: !_isEmail ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _isEmail,
              onChanged: (v) => setState(() => _isEmail = v),
              activeThumbColor: AppColors.white,
              activeTrackColor: AppColors.quinoaDark,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.quinoaDark,
              trackOutlineColor: WidgetStateProperty.all(AppColors.quinoaDark),
            ),
          ),
        ),
        Text(
          AuthStrings.resetViaEmail,
          style: TextStyle(
            color: _isEmail
                ? AppColors.quinoaDark
                : AppColors.quinoaDark.withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: _isEmail ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
