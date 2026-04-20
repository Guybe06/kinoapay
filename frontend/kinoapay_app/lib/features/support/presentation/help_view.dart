import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/features/support/domain/support_strings.dart";

/// Écran Centre d'aide : questions fréquentes avec accordéon.
class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScrollScaffold(
      header: AppBackHeader(
        onBack: () => Navigator.pop(context),
        backLabel: SupportStrings.backLabel,
        title: SupportStrings.helpTitle,
        subtitle: SupportStrings.helpHeaderSubtitle,
      ),
      builder: (_, ctrl) => SingleChildScrollView(
        controller: ctrl,
        padding: const EdgeInsets.fromLTRB(20, 72, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              SupportStrings.helpPageTitle,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              SupportStrings.helpPageSubtitle,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.40),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.quinoaDark.withValues(alpha: 0.06),
                ),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < SupportStrings.faqItems.length; i++)
                    _FaqTile(
                      question: SupportStrings.faqItems[i][0],
                      answer: SupportStrings.faqItems[i][1],
                      showDivider: i < SupportStrings.faqItems.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool showDivider;
  const _FaqTile({
    required this.question,
    required this.answer,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
            iconColor: AppColors.quinoaGold,
            collapsedIconColor: AppColors.quinoaDark.withValues(alpha: 0.30),
            title: Text(
              question,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            children: [
              Text(
                answer,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.60),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 18,
            endIndent: 18,
            color: AppColors.quinoaDark.withValues(alpha: 0.06),
          ),
      ],
    );
  }
}
