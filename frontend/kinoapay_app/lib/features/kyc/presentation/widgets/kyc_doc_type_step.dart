import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/kyc/domain/entities/kyc_document_type.dart";
import "package:kinoapay_app/features/kyc/domain/kyc_strings.dart";

/// Étape 1 : choix du type de document d'identité.
class KycDocTypeStep extends StatefulWidget {
  final ValueChanged<KycDocumentType> onSelected;

  const KycDocTypeStep({super.key, required this.onSelected});

  @override
  State<KycDocTypeStep> createState() => _KycDocTypeStepState();
}

class _KycDocTypeStepState extends State<KycDocTypeStep> {
  KycDocumentType? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 32),
        ...KycDocumentType.values.map(
          (type) => _DocTypeCard(
            type: type,
            isSelected: _selected == type,
            onTap: () => setState(() => _selected = type),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _selected != null
                ? () => widget.onSelected(_selected!)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.quinoaDark,
              foregroundColor: AppColors.quinoaCream,
              disabledBackgroundColor: AppColors.quinoaDark.withValues(alpha: 0.15),
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
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          KycStrings.stepDocTitle,
          style: TextStyle(
            color: AppColors.quinoaDark,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          KycStrings.stepDocSubtitle,
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
}

class _DocTypeCard extends StatelessWidget {
  final KycDocumentType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _DocTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon => switch (type) {
        KycDocumentType.cni => SolarIconsOutline.card,
        KycDocumentType.passport => SolarIconsOutline.passport,
        KycDocumentType.license => SolarIconsOutline.card2,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.quinoaDark.withValues(alpha: 0.05)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.quinoaDark
                : AppColors.quinoaDark.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.quinoaDark
                    : AppColors.quinoaDark.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _icon,
                size: 20,
                color: isSelected ? AppColors.white : AppColors.quinoaDark,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: TextStyle(
                      color: AppColors.quinoaDark,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type.subtitle,
                    style: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.40),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                SolarIconsOutline.checkCircle,
                size: 18,
                color: AppColors.quinoaGold,
              ),
          ],
        ),
      ),
    );
  }
}
