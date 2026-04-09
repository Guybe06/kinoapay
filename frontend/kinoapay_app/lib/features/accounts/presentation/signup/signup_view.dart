import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";
import "package:kinoapay_app/core/navigation/kinoa_router.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/presentation/signin/widgets/auth_button.dart";
import "package:kinoapay_app/features/accounts/presentation/signin/widgets/auth_text_field.dart";

/// Permet aux nouveaux utilisateurs de créer un compte.
class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: KinoaColors.stone900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, KinoaRouter.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const KinoaBrand(size: BrandSize.md),
                      const SizedBox(height: 80),
                      const Text(
                        KinoaStrings.signupTitle,
                        style: TextStyle(
                          color: KinoaColors.stone900,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        KinoaStrings.signupSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: KinoaColors.stone500,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 48),
                      AuthTextField(
                        controller: _emailController,
                        label: KinoaStrings.authEmailLabel,
                        hintText: "exemple@domaine.com",
                        keyboardType: TextInputType.emailAddress,
                        validator: AuthValidator.validateEmailOrPhone,
                      ),
                      const SizedBox(height: 24),
                      AuthTextField(
                        controller: _passwordController,
                        label: KinoaStrings.authPasswordLabel,
                        hintText: "Créer un mot de passe",
                        obscureText: true,
                        validator: AuthValidator.validatePassword,
                      ),
                      const SizedBox(height: 48),
                      AuthButton(
                        text: KinoaStrings.authSubmitBtn,
                        isLoading: state is AuthLoading,
                        onPressed: _submitForm,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: Divider(color: KinoaColors.stone100)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("OU", style: TextStyle(color: KinoaColors.stone300, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                          const Expanded(child: Divider(color: KinoaColors.stone100)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(icon: LucideIcons.github, onPressed: () {}),
                          const SizedBox(width: 20),
                          _SocialButton(icon: LucideIcons.apple, onPressed: () {}),
                        ],
                      ),
                      const SizedBox(height: 48),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, KinoaRouter.signin),
                        child: Text.rich(
                          TextSpan(
                            text: "Déjà un compte ? ",
                            style: const TextStyle(color: KinoaColors.stone500, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Se connecter",
                                style: const TextStyle(color: KinoaColors.primary, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          KinoaStrings.signupTerms,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: KinoaColors.stone400,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpRequested(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    } else {
      _showFirstValidationError();
    }
  }

  void _showFirstValidationError() {
    String? emailError = AuthValidator.validateEmailOrPhone(_emailController.text);
    String? passwordError = AuthValidator.validatePassword(_passwordController.text);
    String? firstError = emailError ?? passwordError;

    if (firstError != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            firstError,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: KinoaColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: KinoaColors.stone200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: KinoaColors.stone900, size: 24),
      ),
    );
  }
}
