import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/features/support/domain/support_strings.dart";

/// Écran Signalement : catégorie + description + envoi.
class ReportIssueView extends StatefulWidget {
  const ReportIssueView({super.key});

  @override
  State<ReportIssueView> createState() => _ReportIssueViewState();
}

class _ReportIssueViewState extends State<ReportIssueView> {
  String? _selectedCategory;
  final TextEditingController _messageCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedCategory == null || _messageCtrl.text.trim().isEmpty) return;
    setState(() => _submitted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          SupportStrings.reportSuccess,
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.quinoaDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollScaffold(
      header: AppBackHeader(
        onBack: () => Navigator.pop(context),
        backLabel: SupportStrings.backLabel,
        title: SupportStrings.reportTitle,
        subtitle: SupportStrings.reportHeaderSubtitle,
      ),
      builder: (_, ctrl) => SingleChildScrollView(
        controller: ctrl,
        padding: const EdgeInsets.fromLTRB(20, 72, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              SupportStrings.reportPageTitle,
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
              SupportStrings.reportPageSubtitle,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.40),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            _label(SupportStrings.reportSectionCategory),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.quinoaDark.withValues(alpha: 0.08),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      SupportStrings.reportCategories.first,
                      style: TextStyle(
                        color: AppColors.quinoaDark.withValues(alpha: 0.35),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  items: SupportStrings.reportCategories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Text(
                              c,
                              style: const TextStyle(
                                color: AppColors.quinoaDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _label(SupportStrings.reportSectionMessage),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.quinoaDark.withValues(alpha: 0.08),
                ),
              ),
              child: TextField(
                controller: _messageCtrl,
                maxLines: 6,
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: SupportStrings.reportMessageHint,
                  hintStyle: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.30),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitted ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.quinoaDark,
                  foregroundColor: AppColors.quinoaCream,
                  disabledBackgroundColor:
                      AppColors.quinoaDark.withValues(alpha: 0.15),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  SupportStrings.reportSubmit,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.35),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      );
}
