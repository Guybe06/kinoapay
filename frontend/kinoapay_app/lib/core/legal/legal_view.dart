import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/legal/kinoa_cgu.dart";
import "package:kinoapay_app/core/legal/kinoa_privacy.dart";

enum LegalDocType { cgu, privacy }

/// Affiche un document légal (CGU ou Politique de confidentialité) en lecture seule.
class LegalView extends StatelessWidget {
  final LegalDocType type;

  const LegalView({super.key, required this.type});

  bool get _isCgu => type == LegalDocType.cgu;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: KinoaColors.quinoaCream,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(28, 8, 28, 48),
                  children: [
                    _buildMeta(),
                    const SizedBox(height: 32),
                    ..._articles().map((a) => _buildArticle(a.$1, a.$2)),
                    const SizedBox(height: 16),
                    _buildContact(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: KinoaColors.quinoaDark),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _isCgu ? KinoaCgu.title : KinoaPrivacy.title,
              style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 16, fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta() {
    final version = _isCgu ? KinoaCgu.version : KinoaPrivacy.version;
    final sub = _isCgu ? KinoaCgu.editor : KinoaPrivacy.controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(version, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.45), fontSize: 13)),
        const SizedBox(height: 4),
        Text(sub, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.45), fontSize: 13)),
        const SizedBox(height: 24),
        Divider(color: KinoaColors.quinoaDark.withValues(alpha: 0.1), height: 1),
      ],
    );
  }

  Widget _buildArticle(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 15, fontWeight: FontWeight.w800, height: 1.2),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.7), fontSize: 14, height: 1.65),
          ),
        ],
      ),
    );
  }

  Widget _buildContact() {
    final email = _isCgu ? KinoaCgu.contactEmail : KinoaPrivacy.contactEmail;
    final label = _isCgu ? KinoaCgu.contactLabel : KinoaPrivacy.contactLabel;
    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: KinoaColors.quinoaDark.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 20),
          Text(label, style: const TextStyle(color: KinoaColors.quinoaGold, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(email, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.6), fontSize: 13)),
        ],
      ),
    );
  }

  List<(String, String)> _articles() => _isCgu ? [
    (KinoaCgu.a1Title, KinoaCgu.a1Body),
    (KinoaCgu.a2Title, KinoaCgu.a2Body),
    (KinoaCgu.a3Title, KinoaCgu.a3Body),
    (KinoaCgu.a4Title, KinoaCgu.a4Body),
    (KinoaCgu.a5Title, KinoaCgu.a5Body),
    (KinoaCgu.a6Title, KinoaCgu.a6Body),
    (KinoaCgu.a7Title, KinoaCgu.a7Body),
    (KinoaCgu.a8Title, KinoaCgu.a8Body),
    (KinoaCgu.a9Title, KinoaCgu.a9Body),
    (KinoaCgu.a10Title, KinoaCgu.a10Body),
  ] : [
    (KinoaPrivacy.a1Title, KinoaPrivacy.a1Body),
    (KinoaPrivacy.a2Title, KinoaPrivacy.a2Body),
    (KinoaPrivacy.a3Title, KinoaPrivacy.a3Body),
    (KinoaPrivacy.a4Title, KinoaPrivacy.a4Body),
    (KinoaPrivacy.a5Title, KinoaPrivacy.a5Body),
    (KinoaPrivacy.a6Title, KinoaPrivacy.a6Body),
    (KinoaPrivacy.a7Title, KinoaPrivacy.a7Body),
    (KinoaPrivacy.a8Title, KinoaPrivacy.a8Body),
    (KinoaPrivacy.a9Title, KinoaPrivacy.a9Body),
    (KinoaPrivacy.a10Title, KinoaPrivacy.a10Body),
  ];
}
