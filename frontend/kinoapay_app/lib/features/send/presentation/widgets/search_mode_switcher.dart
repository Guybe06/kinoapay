import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Segmented pill control — fond blanc, bordure stone légère.
class SearchModeSwitcher extends StatelessWidget {
  final bool isPhoneMode;
  final ValueChanged<bool> onChanged;

  const SearchModeSwitcher({
    super.key,
    required this.isPhoneMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stone200, width: 1),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment:
                isPhoneMode ? Alignment.centerLeft : Alignment.centerRight,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.quinoaDark,
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      SendStrings.switchPhone,
                      style: TextStyle(
                        color: isPhoneMode
                            ? AppColors.quinoaCream
                            : AppColors.quinoaDark.withValues(alpha: 0.4),
                        fontSize: 13,
                        fontWeight:
                            isPhoneMode ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      SendStrings.switchId,
                      style: TextStyle(
                        color: !isPhoneMode
                            ? AppColors.quinoaCream
                            : AppColors.quinoaDark.withValues(alpha: 0.4),
                        fontSize: 13,
                        fontWeight:
                            !isPhoneMode ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
