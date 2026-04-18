import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Toggle Switch entre recherche par numéro de téléphone et par @ID KinoaPay.
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
    return Row(
      children: [
        Text(
          SendStrings.switchPhone,
          style: TextStyle(
            color: isPhoneMode
                ? AppColors.quinoaDark
                : AppColors.quinoaDark.withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: isPhoneMode ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: !isPhoneMode,
              onChanged: (v) => onChanged(!v),
              activeThumbColor: AppColors.white,
              activeTrackColor: AppColors.quinoaDark,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.quinoaDark,
              trackOutlineColor:
                  WidgetStateProperty.all(AppColors.quinoaDark),
            ),
          ),
        ),
        Text(
          SendStrings.switchId,
          style: TextStyle(
            color: !isPhoneMode
                ? AppColors.quinoaDark
                : AppColors.quinoaDark.withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: !isPhoneMode ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
