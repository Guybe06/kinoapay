import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
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
import "package:kinoapay_app/core/widgets/staggered_entrance.dart";

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
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.celebration, (_) => false, arguments: state.user.firstName ?? "");
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

  Widget _buildBody(BuildContext context, AuthState state, SignupStep1Args step1) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            StaggeredEntrance(index: 0, child: SignupStepIndicator(currentStep: 2, totalSteps: 2, label: AuthStrings.stepIndicator2)),
            const SizedBox(height: 24),
            StaggeredEntrance(
              index: 1,
              child: const Text(AuthStrings.signupStep2Title, style: TextStyle(color: AppColors.quinoaDark, fontSize: 42, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -2)),
            ),
            const SizedBox(height: 12),
            StaggeredEntrance(
              index: 2,
              child: Text(AuthStrings.signupStep2Subtitle, style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4)),
            ),
            const SizedBox(height: 40),
            StaggeredEntrance(
              index: 3,
              child: AuthTextField(controller: _emailCtrl, label: AuthStrings.emailLabel, hintText: AuthStrings.emailHint, keyboardType: TextInputType.emailAddress, validator: AuthValidator.validateEmailOrPhone),
            ),
            const SizedBox(height: 20),
            StaggeredEntrance(
              index: 4,
              child: AuthTextField(controller: _passwordCtrl, label: AuthStrings.passwordLabel, hintText: AuthStrings.passwordHint, obscureText: true, validator: AuthValidator.validatePassword),
            ),
            const SizedBox(height: 40),
            StaggeredEntrance(
              index: 5,
              child: PrimaryButton(text: AuthStrings.submitBtn, isLoading: state is AuthLoading, onPressed: () => _submit(step1)),
            ),
            const SizedBox(height: 32),
            const StaggeredEntrance(index: 6, child: AuthSigninLink()),
            const SizedBox(height: 16),
            const StaggeredEntrance(index: 7, child: AuthLegalTerms()),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
