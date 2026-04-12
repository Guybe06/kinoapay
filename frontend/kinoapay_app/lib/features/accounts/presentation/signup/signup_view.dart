import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
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
      body: Stack(
        children: [
          // Arrière-plan dégradé pastel
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE2D1F9),
                    Color(0xFFFEE1C7),
                    Color(0xFFD1F2F9),
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  // Message de succès pour l'inscription en mode Glass
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 2),
                      content: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade900.withValues(alpha: 0.3),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 0.5),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.white),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Compte créé avec succès !",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );

                  // Redirection différée vers Home
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, KinoaRoutes.shell);
                    }
                  });
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 3),
                      content: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: KinoaColors.error.withValues(alpha: 0.3),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 0.5),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.white),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    state.message,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    // Header avec bouton retour
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(LucideIcons.arrowLeft, color: KinoaColors.stone900),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          const KinoaBrand(size: BrandSize.sm),
                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 32),
                              const Text(
                                AuthStrings.signupTitle,
                                style: TextStyle(
                                  color: KinoaColors.stone900,
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  height: 1.0,
                                  letterSpacing: -2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AuthStrings.signupSubtitle,
                                style: TextStyle(
                                  color: KinoaColors.stone900.withValues(alpha: 0.7),
                                  fontSize: 16,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              
                              const SizedBox(height: 48),
                              AuthTextField(
                                controller: _emailController,
                                label: AuthStrings.emailLabel,
                                hintText: "exemple@domaine.com",
                                keyboardType: TextInputType.emailAddress,
                                validator: AuthValidator.validateEmailOrPhone,
                              ),
                              const SizedBox(height: 24),
                              AuthTextField(
                                controller: _passwordController,
                                label: AuthStrings.passwordLabel,
                                hintText: "Créer un mot de passe",
                                obscureText: true,
                                validator: AuthValidator.validatePassword,
                              ),
                              
                              const SizedBox(height: 48),
                              AuthButton(
                                text: AuthStrings.submitBtn,
                                isLoading: state is AuthLoading,
                                onPressed: _submitForm,
                              ),
                              
                              const SizedBox(height: 32),
                              Center(
                                child: Text(
                                  "OU CONTINUER AVEC",
                                  style: TextStyle(
                                    color: KinoaColors.stone900.withValues(alpha: 0.4),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: _SocialButton(
                                      icon: FontAwesomeIcons.google, 
                                      label: "Google",
                                      onPressed: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _SocialButton(
                                      icon: FontAwesomeIcons.apple, 
                                      label: "Apple",
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 48),
                              Center(
                                child: TextButton(
                                  onPressed: () => Navigator.pushReplacementNamed(context, KinoaRoutes.signin),
                                  child: Text.rich(
                                    TextSpan(
                                      text: "Déjà un compte ? ",
                                      style: TextStyle(
                                        color: KinoaColors.stone900.withValues(alpha: 0.6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: "Se connecter",
                                          style: TextStyle(color: KinoaColors.stone900, fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    AuthStrings.signupTerms,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: KinoaColors.stone900.withValues(alpha: 0.4),
                                      fontSize: 12,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          content: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: KinoaColors.error.withValues(alpha: 0.3),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        firstError,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topLeft: Radius.zero,
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    );

    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          border: Border.all(color: KinoaColors.stone900.withValues(alpha: 0.1)),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: KinoaColors.stone900, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: KinoaColors.stone900,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
