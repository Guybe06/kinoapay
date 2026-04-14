import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/core/widgets/kinoa_primary_button.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_social_button.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_text_field.dart";
import "package:kinoapay_app/core/widgets/kinoa_entrance.dart";

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

  void _navigateTo(String route, {Object? arguments}) {
    if (_navigating) return;
    _navigating = true;
    Navigator.pushNamed(context, route, arguments: arguments).then((_) => _navigating = false);
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
        Navigator.pushNamedAndRemoveUntil(context, KinoaRoutes.shell, (_) => false);
      });
    } else if (state is AuthError) {
      AuthSnackBar.showError(listenerCtx, state.exception.message);
    }
  }

  void _handleBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, KinoaRoutes.welcome);
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) => _handleBack(context),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
            onPressed: () => _handleBack(context),
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
            KinoaEntrance(
              index: 0,
              child: const Text(
                AuthStrings.signinTitle,
                style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 42, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -2),
              ),
            ),
            const SizedBox(height: 12),
            KinoaEntrance(
              index: 1,
              child: Text(
                AuthStrings.signinSubtitle,
                style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4),
              ),
            ),
            const SizedBox(height: 40),
            KinoaEntrance(
              index: 2,
              child: AuthTextField(
                controller: _emailCtrl,
                label: AuthStrings.emailLabel,
                hintText: "Email ou numéro mobile",
                keyboardType: TextInputType.emailAddress,
                validator: AuthValidator.validateEmailOrPhone,
              ),
            ),
            const SizedBox(height: 20),
            KinoaEntrance(
              index: 3,
              child: AuthTextField(
                controller: _passwordCtrl,
                label: AuthStrings.passwordLabel,
                hintText: "Mot de passe",
                obscureText: true,
                validator: AuthValidator.validatePassword,
              ),
            ),
            const SizedBox(height: 16),
            KinoaEntrance(index: 4, child: _buildForgotPasswordRow()),
            const SizedBox(height: 40),
            KinoaEntrance(index: 5, child: KinoaPrimaryButton(text: AuthStrings.submitBtn, isLoading: state is AuthLoading, onPressed: _submit)),
            const SizedBox(height: 32),
            KinoaEntrance(index: 6, child: const AuthSocialDivider()),
            const SizedBox(height: 20),
            KinoaEntrance(index: 7, child: const AuthSocialRow()),
            const SizedBox(height: 40),
            KinoaEntrance(index: 8, child: _buildSignupLink(context)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordRow() {
    return GestureDetector(
      onTap: () => _navigateTo(KinoaRoutes.forgotPassword),
      child: Text.rich(
        TextSpan(
          text: "Mot de passe oublié ? ",
          style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.5), fontSize: 14, fontWeight: FontWeight.w500),
          children: const [
            TextSpan(
              text: "Réinitialiser",
              style: TextStyle(
                color: KinoaColors.quinoaDark,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupLink(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => _navigateTo(KinoaRoutes.signup),
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
