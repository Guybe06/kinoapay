import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/legal/legal_bottom_sheet.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";
import "package:kinoapay_app/core/widgets/kinoa_primary_button.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_view.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_text_field.dart";

/// Étape 2 de l'inscription : adresse email et mot de passe, puis soumission.
class SignUpStep2View extends StatefulWidget {
  const SignUpStep2View({super.key});

  @override
  State<SignUpStep2View> createState() => _SignUpStep2ViewState();
}

class _SignUpStep2ViewState extends State<SignUpStep2View> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  SignupStep1Args _step1Args(BuildContext context) =>
      ModalRoute.of(context)!.settings.arguments as SignupStep1Args;

  void _onState(BuildContext listenerCtx, AuthState state) {
    if (state is Authenticated) {
      AuthSnackBar.showSuccess(listenerCtx, AuthStrings.signupSuccess);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, KinoaRoutes.celebration, (_) => false,
            arguments: state.user.firstName ?? "");
      });
    } else if (state is AuthError) {
      AuthSnackBar.showError(listenerCtx, state.exception.message);
    }
  }

  void _submit(SignupStep1Args step1) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      SignUpRequested(
        firstName: step1.firstName,
        lastName: step1.lastName,
        phone: step1.phone,
        countryCode: step1.countryCode,
        birthDate: step1.birthDate,
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
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
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: _onState,
            builder: (context, state) {
              final step1 = _step1Args(context);
              return Column(
                children: [
                  _buildHeader(context),
                  Expanded(child: _buildBody(context, state, step1)),
                ],
              );
            },
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

  Widget _buildBody(BuildContext context, AuthState state, SignupStep1Args step1) {
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
              AuthStrings.signupStep2Title,
              style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 42, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -2),
            ),
            const SizedBox(height: 12),
            Text(
              AuthStrings.signupStep2Subtitle,
              style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 40),
            AuthTextField(
              controller: _emailCtrl,
              label: AuthStrings.emailLabel,
              hintText: "sofia@exemple.com",
              keyboardType: TextInputType.emailAddress,
              validator: AuthValidator.validateEmailOrPhone,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _passwordCtrl,
              label: AuthStrings.passwordLabel,
              hintText: "Créer un mot de passe",
              obscureText: true,
              validator: AuthValidator.validatePassword,
            ),
            const SizedBox(height: 40),
            KinoaPrimaryButton(
              text: AuthStrings.submitBtn,
              isLoading: state is AuthLoading,
              onPressed: () => _submit(step1),
            ),
            const SizedBox(height: 32),
            _buildSigninLink(context),
            const SizedBox(height: 16),
            _buildTerms(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _dot(active: false),
        const SizedBox(width: 6),
        _dot(active: true),
        const SizedBox(width: 10),
        Text(
          "Étape 2 sur 2",
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

  Widget _buildSigninLink(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, KinoaRoutes.signin),
        child: Text.rich(
          TextSpan(
            text: "${AuthStrings.signupHaveAccount} ",
            style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
            children: const [
              TextSpan(
                text: AuthStrings.signupSigninLink,
                style: TextStyle(color: KinoaColors.quinoaDark, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTerms(BuildContext context) {
    final muted = TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.35), fontSize: 12, height: 1.5);
    final link = TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.6), fontSize: 12, height: 1.5, fontWeight: FontWeight.w700, decoration: TextDecoration.underline, decorationColor: KinoaColors.quinoaDark.withValues(alpha: 0.3));

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text("En créant un compte, vous acceptez nos ", style: muted),
            GestureDetector(
              onTap: () => LegalBottomSheet.show(context, LegalDocType.cgu),
              child: Text("Conditions d'utilisation", style: link),
            ),
            Text(" et notre ", style: muted),
            GestureDetector(
              onTap: () => LegalBottomSheet.show(context, LegalDocType.privacy),
              child: Text("Politique de confidentialité", style: link),
            ),
            Text(".", style: muted),
          ],
        ),
      ),
    );
  }
}
