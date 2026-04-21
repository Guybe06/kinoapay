import "dart:io";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/features/kyc/domain/kyc_strings.dart";

/// Étape 3 : capture du selfie pour la vérification de vivacité.
class KycSelfieStep extends StatefulWidget {
  final ValueChanged<String> onSelfieCaptured;
  final VoidCallback onConfirm;

  const KycSelfieStep({
    super.key,
    required this.onSelfieCaptured,
    required this.onConfirm,
  });

  @override
  State<KycSelfieStep> createState() => _KycSelfieStepState();
}

class _KycSelfieStepState extends State<KycSelfieStep> {
  String? _imagePath;
  final _picker = ImagePicker();

  Future<void> _takeSelfie() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1080,
    );
    if (picked == null) return;
    setState(() => _imagePath = picked.path);
    widget.onSelfieCaptured(picked.path);
  }

  @override
  Widget build(BuildContext context) {
    final compact = ScreenSizeHelper.isCompact(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        SizedBox(
          height: ScreenSizeHelper.adaptiveValue(
            context,
            compact: 20,
            small: 24,
            medium: 28,
            large: 32,
          ),
        ),
        _buildSelfieZone(context),
        SizedBox(
          height: ScreenSizeHelper.adaptiveValue(
            context,
            compact: 12,
            small: 14,
            medium: 15,
            large: 16,
          ),
        ),
        _buildHint(),
        SizedBox(
          height: ScreenSizeHelper.adaptiveValue(
            context,
            compact: 28,
            small: 32,
            medium: 36,
            large: 40,
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: compact ? 48 : 56,
          child: ElevatedButton.icon(
            onPressed: _takeSelfie,
            icon: const Icon(SolarIconsOutline.userRounded, size: 18),
            label: Text(
              _imagePath != null
                  ? KycStrings.retakeSelfieBtn
                  : KycStrings.takeSelfieBtn,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.quinoaDark,
              foregroundColor: AppColors.quinoaCream,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
        if (_imagePath != null) ...[
          SizedBox(height: compact ? 10 : 12),
          SizedBox(
            width: double.infinity,
            height: compact ? 48 : 56,
            child: ElevatedButton(
              onPressed: widget.onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.quinoaGold,
                foregroundColor: AppColors.quinoaDark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                KycStrings.continueBtn,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final compact = ScreenSizeHelper.isCompact(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          KycStrings.stepSelfieTitle,
          style: TextStyle(
            color: AppColors.quinoaDark,
            fontSize: compact ? 22 : 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
            height: 1.15,
          ),
        ),
        SizedBox(
          height: ScreenSizeHelper.adaptiveValue(
            context,
            compact: 6,
            small: 7,
            medium: 8,
            large: 8,
          ),
        ),
        Text(
          KycStrings.stepSelfieSubtitle,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.45),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSelfieZone(BuildContext context) {
    final compact = ScreenSizeHelper.isCompact(context);
    final zoneSize = compact ? 160.0 : 200.0;
    return Center(
      child: GestureDetector(
        onTap: _takeSelfie,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: zoneSize,
          height: zoneSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _imagePath != null
                ? Colors.transparent
                : AppColors.quinoaDark.withValues(alpha: 0.04),
            border: Border.all(
              color: _imagePath != null
                  ? AppColors.success.withValues(alpha: 0.5)
                  : AppColors.quinoaDark.withValues(alpha: 0.10),
              width: 2,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: _imagePath != null
              ? Image.file(File(_imagePath!), fit: BoxFit.cover)
              : Icon(
                  SolarIconsOutline.userRounded,
                  size: compact ? 48 : 60,
                  color: AppColors.quinoaDark.withValues(alpha: 0.18),
                ),
        ),
      ),
    );
  }

  Widget _buildHint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          SolarIconsOutline.infoCircle,
          size: 14,
          color: AppColors.quinoaDark.withValues(alpha: 0.30),
        ),
        const SizedBox(width: 6),
        Text(
          KycStrings.selfieHint,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.40),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
