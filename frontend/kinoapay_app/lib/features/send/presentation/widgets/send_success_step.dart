import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/send/domain/transaction_context.dart";

/// Écran affiché après confirmation — animation simple d'apparition icône confirm + texte.
class SendSuccessStep extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onShowNotification;

  /// Contexte hérité : adapte le titre et le message selon send ou pay.
  final TransactionContext context;

  const SendSuccessStep({
    super.key,
    required this.onClose,
    required this.onShowNotification,
    this.context = TransactionContext.send,
  });

  @override
  State<SendSuccessStep> createState() => _SendSuccessStepState();
}

class _SendSuccessStepState extends State<SendSuccessStep>
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
      duration: const Duration(milliseconds: 600),
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
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));

    _iconCtrl.forward();
    Future.delayed(const Duration(milliseconds: 400), _textCtrl.forward);
    Future.delayed(const Duration(seconds: 2), widget.onShowNotification);
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _textCtrl.dispose();
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
              const SizedBox(height: 24),
              _buildCloseButton(),
              const Spacer(flex: 3),
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
            color: AppColors.quinoaDark,
            shape: BoxShape.circle,
          ),
          child: Icon(
            SolarIconsOutline.checkCircle,
            color: AppColors.white,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _textFade,
      child: SlideTransition(
        position: _textSlide,
        child: Column(
          children: [
            Text(
              widget.context.isPay
                  ? SendStrings.paySuccessTitle
                  : SendStrings.successTitle,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.context.isPay
                  ? SendStrings.paySuccessMessage
                  : SendStrings.successMessage,
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
