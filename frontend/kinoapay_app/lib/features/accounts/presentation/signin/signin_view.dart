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

/// Gère l'authentification des utilisateurs existants.
class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

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
                        KinoaStrings.signinTitle,
                        style: TextStyle(
                          color: KinoaColors.stone900,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        KinoaStrings.signinSubtitle,
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
                        hintText: "Email ou numéro mobile",
                        keyboardType: TextInputType.emailAddress,
                        validator: AuthValidator.validateEmailOrPhone,
                      ),
                      const SizedBox(height: 24), // Espacement plus généreux
                      AuthTextField(
                        controller: _passwordController,
                        label: KinoaStrings.authPasswordLabel,
                        hintText: "Mot de passe",
                        obscureText: true,
                        validator: AuthValidator.validatePassword,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.75, // Plus petit, plus discret
                                child: Switch(
                                  value: _rememberMe,
                                  onChanged: (value) => setState(() => _rememberMe = value),
                                  activeColor: Colors.white,
                                  activeTrackColor: KinoaColors.primary,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: KinoaColors.stone100, // Plus clair
                                  trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) return KinoaColors.primary;
                                    return KinoaColors.stone200;
                                  }),
                                  splashRadius: 0,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "Rester connecté",
                                style: TextStyle(
                                  color: KinoaColors.stone500, // Plus doux
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              splashFactory: NoSplash.splashFactory, // Pas de splash ici aussi
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              KinoaStrings.signinForgotPass,
                              style: TextStyle(
                                color: KinoaColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48), // Grand espace avant le bouton
                      AuthButton(
                        text: KinoaStrings.authSubmitBtn,
                        isLoading: state is AuthLoading,
                        onPressed: _submitForm,
                      ),
                      const SizedBox(height: 48),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 0.5, // Ultra fin
                              color: KinoaColors.stone100,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              "OU",
                              style: TextStyle(
                                color: KinoaColors.stone300,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2, // Style très "Design"
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: KinoaColors.stone100,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      AuthButton(
                        text: KinoaStrings.signinSignupLink,
                        isSecondary: true,
                        onPressed: () => Navigator.pushReplacementNamed(context, KinoaRouter.signup),
                      ),
                      const SizedBox(height: 60),
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
        SignInRequested(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    } else {
      // Récupère la première erreur et l'affiche en Toast (Google Pay Style)
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
