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
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_text_field.dart";

/// Écran 3 : saisie du nouveau mot de passe + confirmation.
class ForgotPasswordResetView extends StatefulWidget {
  const ForgotPasswordResetView({super.key});

  @override
  State<ForgotPasswordResetView> createState() =>
      _ForgotPasswordResetViewState();
}

class _ForgotPasswordResetViewState extends State<ForgotPasswordResetView> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String get _resetToken =>
      ModalRoute.of(context)!.settings.arguments as String;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onState(BuildContext ctx, AuthState state) {
    if (state is PasswordResetSuccess) {
      AuthSnackBar.showSuccess(ctx, AuthStrings.resetSuccess);
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.signin,
          (_) => false,
        );
      });
    } else if (state is AuthError) {
      AuthSnackBar.showError(ctx, state.exception.message);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_passCtrl.text != _confirmCtrl.text) {
      AuthSnackBar.showError(context, AuthStrings.resetPassMismatch);
      return;
    }
    context.read<AuthBloc>().add(
      ResetPasswordRequested(
        resetToken: _resetToken,
        newPassword: _passCtrl.text,
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
              AuthStrings.resetNewPassTitle,
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
              AuthStrings.resetNewPassSubtitle,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.55),
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
            AuthTextField(
              controller: _passCtrl,
              label: AuthStrings.resetNewPassLabel,
              hintText: AuthStrings.resetNewPassHint,
              obscureText: true,
              validator: AuthValidator.validatePassword,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _confirmCtrl,
              label: AuthStrings.resetConfirmPassLabel,
              hintText: AuthStrings.resetConfirmPassHint,
              obscureText: true,
              validator: AuthValidator.validatePassword,
            ),
            const SizedBox(height: 48),
            PrimaryButton(
              text: AuthStrings.submitBtn,
              isLoading: state is AuthLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
