import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Étape de validation USSD pending - utilisateur valide via son opérateur.
class UssdValidationStep extends StatefulWidget {
  final VoidCallback onResolved;

  const UssdValidationStep({super.key, required this.onResolved});

  @override
  State<UssdValidationStep> createState() => _UssdValidationStepState();
}

class _UssdValidationStepState extends State<UssdValidationStep>
    with TickerProviderStateMixin {
  AnimationController? _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      widget.onResolved();
    });
  }

  @override
  void dispose() {
    _pulseCtrl?.dispose();
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
              _buildPendingIcon(),
              const SizedBox(height: 32),
              _buildContent(),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingIcon() {
    return AnimatedBuilder(
      animation: _pulseCtrl ?? const AlwaysStoppedAnimation(0),
      builder: (_, __) {
        return Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.quinoaGold.withValues(
              alpha: 0.12 + ((_pulseCtrl?.value ?? 0) * 0.08),
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            SolarIconsOutline.hourglass,
            color: AppColors.quinoaGold,
            size: 36,
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const Text(
          SendStrings.ussdTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.quinoaDark,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          SendStrings.ussdMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.5),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
