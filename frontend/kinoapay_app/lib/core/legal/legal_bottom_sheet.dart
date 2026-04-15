import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/legal/kinoa_cgu.dart";
import "package:kinoapay_app/core/legal/kinoa_privacy.dart";

/// Types de documents légaux disponibles dans l'application.
enum LegalDocType { cgu, privacy }

/// Affiche un document légal (CGU ou Politique de confidentialité) dans un bottom sheet draggable.
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
          color: KinoaColors.quinoaCream,
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
          color: KinoaColors.quinoaDark.withValues(alpha: 0.15),
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
              _isCgu ? KinoaCgu.title : KinoaPrivacy.title,
              style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
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
        Text(version, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 12)),
        const SizedBox(height: 2),
        Text(sub, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 12)),
        const SizedBox(height: 20),
        Divider(color: KinoaColors.quinoaDark.withValues(alpha: 0.1), height: 1),
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
            style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.justify,
            style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.65), fontSize: 13, height: 1.65),
          ),
        ],
      ),
    );
  }

  Widget _buildContact() {
    final email = _isCgu ? KinoaCgu.contactEmail : KinoaPrivacy.contactEmail;
    final label = _isCgu ? KinoaCgu.contactLabel : KinoaPrivacy.contactLabel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: KinoaColors.quinoaDark.withValues(alpha: 0.1), height: 1),
        const SizedBox(height: 18),
        Text(label, style: const TextStyle(color: KinoaColors.quinoaGold, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(email, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.55), fontSize: 13)),
      ],
    );
  }

  List<(String, String)> _articles() => _isCgu
      ? [
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
        ]
      : [
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
