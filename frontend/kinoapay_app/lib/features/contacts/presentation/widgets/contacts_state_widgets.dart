import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Squelette de chargement : affiche des tuiles fantômes pendant le fetch initial.
class ContactsLoadingWidget extends StatelessWidget {
  const ContactsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: 8,
      itemBuilder: (_, i) => const _ContactSkeletonTile(),
    );
  }
}

/// Tuile squelette individuelle pour l'état de chargement.
class _ContactSkeletonTile extends StatelessWidget {
  const _ContactSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          _Bone(width: 46, height: 46, radius: 23),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bone(width: 140, height: 13, radius: 6),
                const SizedBox(height: 6),
                _Bone(width: 90, height: 10, radius: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bloc de couleur neutre simulant un élément en chargement.
class _Bone extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _Bone({required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.quinoaDark.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Squelette de bas de liste : indique qu'une page supplémentaire se charge.
class ContactsLoadMoreSkeleton extends StatelessWidget {
  const ContactsLoadMoreSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        children: List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                _Bone(width: 46, height: 46, radius: 23),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bone(width: 130, height: 13, radius: 6),
                      SizedBox(height: 6),
                      _Bone(width: 80, height: 10, radius: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Message d'erreur affiché si le chargement des contacts échoue.
class ContactsErrorWidget extends StatelessWidget {
  final String message;

  const ContactsErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.45),
          fontSize: 14,
        ),
      ),
    );
  }
}
