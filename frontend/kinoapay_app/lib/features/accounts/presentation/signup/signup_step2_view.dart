import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_args.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_step_indicator.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_legal_terms.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_screen_header.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_signin_link.dart";
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
  bool _navigating = false;

  void _navigateTo(String route) {
    if (_navigating || !mounted) return;
    _navigating = true;
    Navigator.pushNamed(context, route).then((_) => _navigating = false);
  }

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
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.celebration,
          (_) => false,
          arguments: state.user.firstName ?? "",
        );
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
        backgroundColor: AppColors.quinoaCream,
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: _onState,
            builder: (context, state) {
              final step1 = _step1Args(context);
              return Column(
                children: [
                  const AuthScreenHeader(),
                  Expanded(child: _buildBody(context, state, step1)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AuthState state,
    SignupStep1Args step1,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 20,
                small: 24,
                medium: 28,
                large: 32,
              ),
            ),
            SignupStepIndicator(
              currentStep: 2,
              totalSteps: 2,
              label: AuthStrings.stepIndicator2,
            ),
            SizedBox(
              height: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 16,
                small: 20,
                medium: 22,
                large: 24,
              ),
            ),
            Text(
              AuthStrings.signupStep2Title,
              style: TextStyle(
                color: AppColors.quinoaDark,
                fontSize: ScreenSizeHelper.adaptiveValue(
                  context,
                  compact: 32,
                  small: 36,
                  medium: 40,
                  large: 42,
                ),
                fontWeight: FontWeight.w900,
                height: 1.0,
                letterSpacing: -2,
              ),
            ),
            SizedBox(
              height: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 8,
                small: 10,
                medium: 11,
                large: 12,
              ),
            ),
            Text(
              AuthStrings.signupStep2Subtitle,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.55),
                fontSize: 15,
                height: 1.4,
              ),
            ),
            SizedBox(
              height: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 24,
                small: 30,
                medium: 36,
                large: 40,
              ),
            ),
            AuthTextField(
              controller: _emailCtrl,
              label: AuthStrings.emailLabel,
              hintText: AuthStrings.emailHint,
              keyboardType: TextInputType.emailAddress,
              validator: AuthValidator.validateEmailOrPhone,
            ),
            SizedBox(
              height: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 12,
                small: 16,
                medium: 18,
                large: 20,
              ),
            ),
            AuthTextField(
              controller: _passwordCtrl,
              label: AuthStrings.passwordLabel,
              hintText: AuthStrings.passwordHint,
              obscureText: true,
              validator: AuthValidator.validatePassword,
            ),
            SizedBox(
              height: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 28,
                small: 36,
                medium: 40,
                large: 40,
              ),
            ),
            PrimaryButton(
              text: AuthStrings.submitBtn,
              isLoading: state is AuthLoading,
              onPressed: () => _submit(step1),
            ),
            SizedBox(
              height: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 20,
                small: 26,
                medium: 32,
                large: 32,
              ),
            ),
            AuthSigninLink(onTap: () => _navigateTo(AppRoutes.signin)),
            SizedBox(
              height: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 10,
                small: 12,
                medium: 16,
                large: 16,
              ),
            ),
            const AuthLegalTerms(),
            SizedBox(
              height: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 16,
                small: 20,
                medium: 32,
                large: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
