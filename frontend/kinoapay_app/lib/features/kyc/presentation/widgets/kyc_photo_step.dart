import "dart:io";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/features/kyc/domain/kyc_strings.dart";

/// Étape 2 : capture de la photo recto du document d'identité.
class KycPhotoStep extends StatefulWidget {
  final ValueChanged<String> onPhotoCaptured;

  const KycPhotoStep({super.key, required this.onPhotoCaptured});

  @override
  State<KycPhotoStep> createState() => _KycPhotoStepState();
}

class _KycPhotoStepState extends State<KycPhotoStep> {
  String? _imagePath;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (picked == null) return;
    setState(() => _imagePath = picked.path);
    widget.onPhotoCaptured(picked.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        SizedBox(
          height: ScreenSizeHelper.adaptiveValue(
            context,
            compact: 12,
            small: 20,
            medium: 28,
            large: 32,
          ),
        ),
        _buildPhotoZone(context),
        SizedBox(
          height: ScreenSizeHelper.adaptiveValue(
            context,
            compact: 12,
            small: 14,
            medium: 16,
            large: 16,
          ),
        ),
        _buildHint(),
        SizedBox(
          height: ScreenSizeHelper.adaptiveValue(
            context,
            compact: 24,
            small: 28,
            medium: 30,
            large: 32,
          ),
        ),
        _buildActions(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final compact = ScreenSizeHelper.isCompact(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          KycStrings.stepPhotoTitle,
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
          KycStrings.stepPhotoSubtitle,
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

  Widget _buildPhotoZone(BuildContext context) {
    final compact = ScreenSizeHelper.isCompact(context);
    return GestureDetector(
      onTap: () => _pickImage(ImageSource.camera),
      child: Container(
        width: double.infinity,
        height: compact ? 160 : 200,
        decoration: BoxDecoration(
          color: _imagePath != null
              ? Colors.transparent
              : AppColors.quinoaDark.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _imagePath != null
                ? AppColors.success.withValues(alpha: 0.4)
                : AppColors.quinoaDark.withValues(alpha: 0.10),
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: _imagePath != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(_imagePath!), fit: BoxFit.cover),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    SolarIconsOutline.camera,
                    size: 36,
                    color: AppColors.quinoaDark.withValues(alpha: 0.25),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    KycStrings.takePhotoBtn,
                    style: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.40),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHint() {
    return Row(
      children: [
        Icon(
          SolarIconsOutline.infoCircle,
          size: 14,
          color: AppColors.quinoaDark.withValues(alpha: 0.30),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            KycStrings.photoHint,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.40),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final compact = ScreenSizeHelper.isCompact(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: compact ? 48 : 56,
          child: ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(SolarIconsOutline.camera, size: 18),
            label: Text(
              _imagePath != null
                  ? KycStrings.retakePhotoBtn
                  : KycStrings.takePhotoBtn,
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
        SizedBox(height: compact ? 8 : 10),
        SizedBox(
          width: double.infinity,
          height: compact ? 44 : 48,
          child: TextButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: Icon(
              SolarIconsOutline.gallery,
              size: 16,
              color: AppColors.quinoaDark.withValues(alpha: 0.6),
            ),
            label: Text(
              KycStrings.galleryBtn,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
