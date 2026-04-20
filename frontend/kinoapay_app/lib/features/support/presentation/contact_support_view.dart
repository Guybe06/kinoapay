import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:solar_icons/solar_icons.dart";
import "package:url_launcher/url_launcher.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/features/support/domain/support_strings.dart";

/// Écran Contacter le support : email, WhatsApp et disponibilité.
class ContactSupportView extends StatelessWidget {
  const ContactSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScrollScaffold(
      header: AppBackHeader(
        onBack: () => Navigator.pop(context),
        backLabel: SupportStrings.backLabel,
        title: SupportStrings.contactTitle,
        subtitle: SupportStrings.contactHeaderSubtitle,
      ),
      builder: (_, ctrl) => SingleChildScrollView(
        controller: ctrl,
        padding: const EdgeInsets.fromLTRB(20, 72, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              SupportStrings.contactPageTitle,
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
              SupportStrings.contactPageSubtitle,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.40),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            _ContactCard(
              sectionLabel: SupportStrings.contactSectionEmail,
              icon: SolarIconsOutline.letter,
              label: SupportStrings.contactEmail,
              trailing: GestureDetector(
                onTap: () async {
                  await Clipboard.setData(
                    const ClipboardData(text: SupportStrings.contactEmail),
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        SupportStrings.contactEmailCopied,
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.quinoaDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: Icon(
                  SolarIconsOutline.copy,
                  size: 18,
                  color: AppColors.quinoaDark.withValues(alpha: 0.30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ContactCard(
              sectionLabel: SupportStrings.contactSectionWhatsapp,
              icon: SolarIconsOutline.chatRound,
              label: SupportStrings.contactWhatsapp,
              description: SupportStrings.contactWhatsappDesc,
              onTap: () async {
                final uri = Uri.parse(SupportStrings.contactWhatsappUrl);
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
              trailing: Icon(
                SolarIconsOutline.altArrowRight,
                size: 16,
                color: AppColors.quinoaDark.withValues(alpha: 0.25),
              ),
            ),
            const SizedBox(height: 16),
            _ContactCard(
              sectionLabel: SupportStrings.contactSectionHours,
              icon: SolarIconsOutline.clockCircle,
              label: SupportStrings.contactHours,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String sectionLabel;
  final IconData icon;
  final String label;
  final String? description;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ContactCard({
    required this.sectionLabel,
    required this.icon,
    required this.label,
    this.description,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionLabel,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.35),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.quinoaDark.withValues(alpha: 0.06),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.quinoaGold),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: AppColors.quinoaDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          description!,
                          style: TextStyle(
                            color: AppColors.quinoaDark.withValues(alpha: 0.45),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
