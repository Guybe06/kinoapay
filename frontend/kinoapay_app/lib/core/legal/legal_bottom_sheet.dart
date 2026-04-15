import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/legal/cgu_content.dart";
import "package:kinoapay_app/core/legal/privacy_content.dart";

/// Types de documents légaux affichables dans un bottom sheet.
enum LegalDocType { cgu, privacy }

/// Document légal (CGU ou confidentialité) dans un bottom sheet draggable.
class LegalBottomSheet extends StatelessWidget {
  final LegalDocType type;

  const LegalBottomSheet({super.key, required this.type});

  bool get _isCgu => type == LegalDocType.cgu;

  /// Ouvre le bottom sheet pour le document [type].
  /// @return void
  static void show(BuildContext context, LegalDocType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LegalBottomSheet(type: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.62, 0.95],
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.quinoaCream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            _buildHandle(),
            _buildTitle(),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 48),
                children: [
                  _buildMeta(),
                  const SizedBox(height: 28),
                  ..._articles().map((a) => _buildArticle(a.$1, a.$2)),
                  const SizedBox(height: 16),
                  _buildContact(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _isCgu ? CguContent.title : PrivacyContent.title,
              style: const TextStyle(color: AppColors.quinoaDark, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta() {
    final version = _isCgu ? CguContent.version : PrivacyContent.version;
    final sub = _isCgu ? CguContent.editor : PrivacyContent.controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(version, style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.4), fontSize: 12)),
        const SizedBox(height: 2),
        Text(sub, style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.4), fontSize: 12)),
        const SizedBox(height: 20),
        Divider(color: AppColors.quinoaDark.withValues(alpha: 0.1), height: 1),
      ],
    );
  }

  Widget _buildArticle(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.quinoaDark, fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.justify,
            style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.65), fontSize: 13, height: 1.65),
          ),
        ],
      ),
    );
  }

  Widget _buildContact() {
    final email = _isCgu ? CguContent.contactEmail : PrivacyContent.contactEmail;
    final label = _isCgu ? CguContent.contactLabel : PrivacyContent.contactLabel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: AppColors.quinoaDark.withValues(alpha: 0.1), height: 1),
        const SizedBox(height: 18),
        Text(label, style: const TextStyle(color: AppColors.quinoaGold, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(email, style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.55), fontSize: 13)),
      ],
    );
  }

  List<(String, String)> _articles() => _isCgu
      ? [
          (CguContent.a1Title, CguContent.a1Body),
          (CguContent.a2Title, CguContent.a2Body),
          (CguContent.a3Title, CguContent.a3Body),
          (CguContent.a4Title, CguContent.a4Body),
          (CguContent.a5Title, CguContent.a5Body),
          (CguContent.a6Title, CguContent.a6Body),
          (CguContent.a7Title, CguContent.a7Body),
          (CguContent.a8Title, CguContent.a8Body),
          (CguContent.a9Title, CguContent.a9Body),
          (CguContent.a10Title, CguContent.a10Body),
        ]
      : [
          (PrivacyContent.a1Title, PrivacyContent.a1Body),
          (PrivacyContent.a2Title, PrivacyContent.a2Body),
          (PrivacyContent.a3Title, PrivacyContent.a3Body),
          (PrivacyContent.a4Title, PrivacyContent.a4Body),
          (PrivacyContent.a5Title, PrivacyContent.a5Body),
          (PrivacyContent.a6Title, PrivacyContent.a6Body),
          (PrivacyContent.a7Title, PrivacyContent.a7Body),
          (PrivacyContent.a8Title, PrivacyContent.a8Body),
          (PrivacyContent.a9Title, PrivacyContent.a9Body),
          (PrivacyContent.a10Title, PrivacyContent.a10Body),
        ];
}
