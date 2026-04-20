import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/features/profile/domain/preferences_strings.dart";

/// Écran Préférences : langue, notifications et affichage.
class PreferencesView extends StatefulWidget {
  const PreferencesView({super.key});

  @override
  State<PreferencesView> createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  bool _notifTransactions = true;
  bool _notifAccount = true;
  bool _notifPromo = false;

  @override
  Widget build(BuildContext context) {
    return AppScrollScaffold(
      header: AppBackHeader(
        onBack: () => Navigator.pop(context),
        backLabel: PreferencesStrings.backLabel,
        title: PreferencesStrings.title,
        subtitle: PreferencesStrings.headerSubtitle,
      ),
      builder: (_, ctrl) => SingleChildScrollView(
        controller: ctrl,
        padding: const EdgeInsets.fromLTRB(20, 72, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              PreferencesStrings.pageTitle,
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
              PreferencesStrings.pageSubtitle,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.40),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            _SectionCard(
              label: PreferencesStrings.sectionLanguage,
              children: [
                _PrefRow(
                  label: PreferencesStrings.language,
                  trailing: Text(
                    PreferencesStrings.languageFr,
                    style: const TextStyle(
                      color: AppColors.quinoaGold,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              label: PreferencesStrings.sectionNotifications,
              children: [
                _SwitchRow(
                  label: PreferencesStrings.notifTransactions,
                  description: PreferencesStrings.notifTransactionsDesc,
                  value: _notifTransactions,
                  onChanged: (v) => setState(() => _notifTransactions = v),
                ),
                _SwitchRow(
                  label: PreferencesStrings.notifAccount,
                  description: PreferencesStrings.notifAccountDesc,
                  value: _notifAccount,
                  onChanged: (v) => setState(() => _notifAccount = v),
                ),
                _SwitchRow(
                  label: PreferencesStrings.notifPromo,
                  description: PreferencesStrings.notifPromoDesc,
                  value: _notifPromo,
                  onChanged: (v) => setState(() => _notifPromo = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              label: PreferencesStrings.sectionDisplay,
              children: [
                _PrefRow(
                  label: PreferencesStrings.darkMode,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      PreferencesStrings.darkModeDesc,
                      style: TextStyle(
                        color: AppColors.quinoaDark.withValues(alpha: 0.40),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
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

class _PrefRow extends StatelessWidget {
  final String label;
  final Widget trailing;
  const _PrefRow({required this.label, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.quinoaDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.quinoaGold,
          ),
        ],
      ),
    );
  }
}
