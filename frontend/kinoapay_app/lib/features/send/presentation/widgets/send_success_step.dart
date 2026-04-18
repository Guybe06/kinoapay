import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Écran affiché après confirmation — animation d'envoi + message de traitement.
class SendSuccessStep extends StatefulWidget {
  final VoidCallback onClose;

  const SendSuccessStep({super.key, required this.onClose});

  @override
  State<SendSuccessStep> createState() => _SendSuccessStepState();
}

class _SendSuccessStepState extends State<SendSuccessStep>
    with TickerProviderStateMixin {
  late final AnimationController _iconCtrl;
  late final AnimationController _contentCtrl;
  late final Animation<double> _iconScale;
  late final Animation<double> _iconFade;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _iconScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.elasticOut));
    _iconFade = CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut);
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic),
        );

    _iconCtrl.forward();
    Future.delayed(const Duration(milliseconds: 400), _contentCtrl.forward);
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildIcon(),
              const SizedBox(height: 32),
              _buildContent(),
              const Spacer(flex: 3),
              _buildCloseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return FadeTransition(
      opacity: _iconFade,
      child: ScaleTransition(
        scale: _iconScale,
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.quinoaGold.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            SolarIconsOutline.sendSquare,
            color: AppColors.quinoaGold,
            size: 36,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _contentFade,
      child: SlideTransition(
        position: _contentSlide,
        child: Column(
          children: [
            const Text(
              SendStrings.successTitle,
              style: TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              SendStrings.successMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
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
          SendStrings.successBackBtn,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }
}
