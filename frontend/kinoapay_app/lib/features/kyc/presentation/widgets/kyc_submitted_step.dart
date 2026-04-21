import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/features/kyc/domain/kyc_strings.dart";

/// Étape 4 : confirmation de soumission, dossier en attente de validation.
class KycSubmittedStep extends StatefulWidget {
  final VoidCallback onClose;

  const KycSubmittedStep({super.key, required this.onClose});

  @override
  State<KycSubmittedStep> createState() => _KycSubmittedStepState();
}

class _KycSubmittedStepState extends State<KycSubmittedStep>
    with TickerProviderStateMixin {
  late final AnimationController _iconCtrl;
  late final AnimationController _textCtrl;
  late final Animation<double> _iconScale;
  late final Animation<double> _iconFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _iconScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.elasticOut));
    _iconFade = CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut);
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));

    _iconCtrl.forward();
    Future.delayed(const Duration(milliseconds: 400), _textCtrl.forward);
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = ScreenSizeHelper.isCompact(context);
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            32,
            0,
            32,
            ScreenSizeHelper.adaptiveValue(
              context,
              compact: 24,
              small: 28,
              medium: 32,
              large: 32,
            ),
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildIcon(compact),
              SizedBox(
                height: ScreenSizeHelper.adaptiveValue(
                  context,
                  compact: 24,
                  small: 28,
                  medium: 30,
                  large: 32,
                ),
              ),
              _buildContent(compact),
              const Spacer(flex: 3),
              _buildCloseButton(compact),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool compact) {
    return FadeTransition(
      opacity: _iconFade,
      child: ScaleTransition(
        scale: _iconScale,
        child: Container(
          width: compact ? 72 : 88,
          height: compact ? 72 : 88,
          decoration: const BoxDecoration(
            color: AppColors.quinoaGold,
            shape: BoxShape.circle,
          ),
          child: Icon(
            SolarIconsOutline.shieldCheck,
            color: AppColors.white,
            size: compact ? 32 : 40,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool compact) {
    return FadeTransition(
      opacity: _textFade,
      child: SlideTransition(
        position: _textSlide,
        child: Column(
          children: [
            Text(
              KycStrings.stepSubmittedTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.quinoaDark,
                fontSize: compact ? 22 : 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
                height: 1.1,
              ),
            ),
            SizedBox(
              height: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 10,
                small: 12,
                medium: 13,
                large: 14,
              ),
            ),
            Text(
              KycStrings.stepSubmittedSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.quinoaGold.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.quinoaGold.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    SolarIconsOutline.clockCircle,
                    size: 16,
                    color: AppColors.quinoaGold,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      KycStrings.submittedNote,
                      style: TextStyle(
                        color: AppColors.quinoaDark.withValues(alpha: 0.60),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(bool compact) {
    return SizedBox(
      width: double.infinity,
      height: compact ? 48 : 56,
      child: ElevatedButton(
        onPressed: widget.onClose,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.quinoaDark,
          foregroundColor: AppColors.quinoaCream,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          KycStrings.backHomeBtn,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }
}
