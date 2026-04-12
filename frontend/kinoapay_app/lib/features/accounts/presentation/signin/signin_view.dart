import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_button.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_social_button.dart";
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
  bool _rememberMe = false;

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
        Navigator.pushNamedAndRemoveUntil(context, KinoaRoutes.shell, (_) => false);
      });
    } else if (state is AuthError) {
      AuthSnackBar.showError(listenerCtx, state.exception.message);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInRequested(_emailCtrl.text.trim(), _passwordCtrl.text.trim()),
      );
    }
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
            builder: (context, state) => Column(
              children: [
                _buildHeader(context),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
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

  Widget _buildBody(BuildContext context, AuthState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              AuthStrings.signinTitle,
              style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 42, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -2),
            ),
            const SizedBox(height: 12),
            Text(
              AuthStrings.signinSubtitle,
              style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 40),
            AuthTextField(
              controller: _emailCtrl,
              label: AuthStrings.emailLabel,
              hintText: "Email ou numéro mobile",
              keyboardType: TextInputType.emailAddress,
              validator: AuthValidator.validateEmailOrPhone,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _passwordCtrl,
              label: AuthStrings.passwordLabel,
              hintText: "Mot de passe",
              obscureText: true,
              validator: AuthValidator.validatePassword,
            ),
            const SizedBox(height: 16),
            _buildSwitchRow(),
            const SizedBox(height: 40),
            AuthButton(text: AuthStrings.submitBtn, isLoading: state is AuthLoading, onPressed: _submit),
            const SizedBox(height: 32),
            const AuthSocialDivider(),
            const SizedBox(height: 20),
            const AuthSocialRow(),
            const SizedBox(height: 40),
            _buildSignupLink(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: _rememberMe,
                onChanged: (v) => setState(() => _rememberMe = v),
                activeThumbColor: KinoaColors.white,
                activeTrackColor: KinoaColors.quinoaDark,
                inactiveThumbColor: KinoaColors.white,
                inactiveTrackColor: KinoaColors.quinoaDark.withValues(alpha: 0.1),
                trackOutlineColor: WidgetStateProperty.resolveWith(
                  (s) => s.contains(WidgetState.selected) ? KinoaColors.quinoaDark : KinoaColors.quinoaDark.withValues(alpha: 0.1),
                ),
              ),
            ),
            Text(
              "Rester connecté",
              style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.6), fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            AuthStrings.signinForgotPass,
            style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupLink(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushReplacementNamed(context, KinoaRoutes.signup),
        child: Text.rich(
          TextSpan(
            text: "${AuthStrings.signinNoAccount} ",
            style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
            children: const [
              TextSpan(
                text: AuthStrings.signinSignupLink,
                style: TextStyle(color: KinoaColors.quinoaDark, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
