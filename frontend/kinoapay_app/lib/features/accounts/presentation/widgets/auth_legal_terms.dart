import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/legal/legal_bottom_sheet.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Bandeau légal CGU + politique de confidentialité pour l'inscription.
class AuthLegalTerms extends StatelessWidget {
  const AuthLegalTerms({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.35), fontSize: 12, height: 1.5);
    final link = TextStyle(
      color: AppColors.quinoaDark.withValues(alpha: 0.6),
      fontSize: 12,
      height: 1.5,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.quinoaDark.withValues(alpha: 0.3),
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(AuthStrings.legalPrefix, style: muted),
            GestureDetector(
              onTap: () => LegalBottomSheet.show(context, LegalDocType.cgu),
              child: Text(AuthStrings.legalCgu, style: link),
            ),
            Text(AuthStrings.legalAnd, style: muted),
            GestureDetector(
              onTap: () => LegalBottomSheet.show(context, LegalDocType.privacy),
              child: Text(AuthStrings.legalPrivacy, style: link),
            ),
            Text(".", style: muted),
          ],
        ),
      ),
    );
  }
}
