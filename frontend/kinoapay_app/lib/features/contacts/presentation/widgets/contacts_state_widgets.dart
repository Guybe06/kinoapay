import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Indicateur de chargement de la liste de contacts.
class ContactsLoadingWidget extends StatelessWidget {
  const ContactsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.quinoaGold,
        strokeWidth: 2,
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
        style: const TextStyle(color: AppColors.quinoaGold, fontSize: 14),
      ),
    );
  }
}
