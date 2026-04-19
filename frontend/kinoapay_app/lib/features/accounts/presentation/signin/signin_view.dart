import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_forgot_password_link.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_screen_header.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_social_divider.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_social_row.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_signup_link.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_text_field.dart";

/// Gère l'authentification des utilisateurs existants.
class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
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

  void _onState(BuildContext listenerCtx, AuthState state) {
    if (state is Authenticated) {
      AuthSnackBar.showSuccess(listenerCtx, AuthStrings.signinSuccess);
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.shell, (_) => false);
      });
    } else if (state is AuthError) {
      AuthSnackBar.showError(listenerCtx, state.exception.message);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(SignInRequested(_emailCtrl.text.trim(), _passwordCtrl.text.trim()));
    }
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
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AuthState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(AuthStrings.signinTitle, style: TextStyle(color: AppColors.quinoaDark, fontSize: 42, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -2)),
            const SizedBox(height: 12),
            Text(AuthStrings.signinSubtitle, style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4)),
            const SizedBox(height: 40),
            AuthTextField(controller: _emailCtrl, label: AuthStrings.emailLabel, hintText: AuthStrings.signinEmailHint, keyboardType: TextInputType.emailAddress, validator: AuthValidator.validateEmailOrPhone),
            const SizedBox(height: 20),
            AuthTextField(controller: _passwordCtrl, label: AuthStrings.passwordLabel, hintText: AuthStrings.signinPasswordHint, obscureText: true, validator: AuthValidator.validatePassword),
            const SizedBox(height: 16),
            AuthForgotPasswordLink(onTap: () => _navigateTo(AppRoutes.forgotPassword)),
            const SizedBox(height: 40),
            PrimaryButton(text: AuthStrings.submitBtn, isLoading: state is AuthLoading, onPressed: _submit),
            const SizedBox(height: 32),
            const AuthSocialDivider(),
            const SizedBox(height: 20),
            const AuthSocialRow(),
            const SizedBox(height: 40),
            AuthSignupLink(onTap: () => _navigateTo(AppRoutes.signup)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
