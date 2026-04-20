import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/features/profile/domain/security_strings.dart";

/// Écran Sécurité : gestion du mot de passe, PIN et sessions.
class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  bool _pinEnabled = false;
  bool _biometricEnabled = false;

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          SecurityStrings.comingSoon,
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.quinoaDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollScaffold(
      header: AppBackHeader(
        onBack: () => Navigator.pop(context),
        backLabel: SecurityStrings.backLabel,
        title: SecurityStrings.title,
        subtitle: SecurityStrings.headerSubtitle,
      ),
      builder: (_, ctrl) => SingleChildScrollView(
        controller: ctrl,
        padding: const EdgeInsets.fromLTRB(20, 72, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              SecurityStrings.pageTitle,
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
              SecurityStrings.pageSubtitle,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.40),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            _SectionCard(
              label: SecurityStrings.sectionPassword,
              children: [
                _SettingRow(
                  label: SecurityStrings.password,
                  description: SecurityStrings.passwordDesc,
                  trailing: GestureDetector(
                    onTap: _showComingSoon,
                    child: Text(
                      SecurityStrings.passwordChange,
                      style: const TextStyle(
                        color: AppColors.quinoaGold,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              label: SecurityStrings.sectionAuth,
              children: [
                _SettingRow(
                  label: SecurityStrings.pin,
                  description: SecurityStrings.pinDesc,
                  trailing: Switch(
                    value: _pinEnabled,
                    onChanged: (v) => setState(() => _pinEnabled = v),
                    activeColor: AppColors.quinoaGold,
                  ),
                ),
                _SettingRow(
                  label: SecurityStrings.biometric,
                  description: SecurityStrings.biometricDesc,
                  trailing: Switch(
                    value: _biometricEnabled,
                    onChanged: (v) => setState(() => _biometricEnabled = v),
                    activeColor: AppColors.quinoaGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              label: SecurityStrings.sectionSessions,
              children: [
                _SettingRow(
                  label: SecurityStrings.session,
                  description: SecurityStrings.sessionDevice,
                  trailing: GestureDetector(
                    onTap: _showComingSoon,
                    child: Text(
                      SecurityStrings.sessionDisconnect,
                      style: const TextStyle(
                        color: AppColors.quinoaRed,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String label;
  final List<Widget> children;
  const _SectionCard({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.35),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.06),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String description;
  final Widget trailing;
  const _SettingRow({
    required this.label,
    required this.description,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
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
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.45),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
  }
}
