import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/widgets/kinoa_primary_button.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Écran de célébration post-inscription, affiché après la création du compte.
class CelebrationView extends StatefulWidget {
  const CelebrationView({super.key});

  @override
  State<CelebrationView> createState() => _CelebrationViewState();
}

class _CelebrationViewState extends State<CelebrationView> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleUp;

  String get _firstName {
    final args = ModalRoute.of(context)?.settings.arguments;
    return args is String && args.isNotEmpty ? args : "vous";
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn = CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6, curve: Curves.easeOut));
    _scaleUp = Tween<double>(begin: 0.82, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5, curve: Curves.easeOutBack)));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _continue() {
    Navigator.pushReplacementNamed(context, KinoaRoutes.kycAwareness);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: KinoaColors.quinoaCream,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  ScaleTransition(
                    scale: _scaleUp,
                    child: _buildIcon(),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "${AuthStrings.celebrationSubtitlePrefix} $_firstName !",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: KinoaColors.quinoaDark,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AuthStrings.celebrationBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: KinoaColors.quinoaDark.withValues(alpha: 0.55),
                      fontSize: 16,
                      height: 1.55,
                    ),
                  ),
                  const Spacer(flex: 3),
                  KinoaPrimaryButton(text: "Continuer", onPressed: _continue),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        color: KinoaColors.quinoaGold.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: KinoaColors.quinoaGold,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: KinoaColors.white, size: 40),
        ),
      ),
    );
  }
}
