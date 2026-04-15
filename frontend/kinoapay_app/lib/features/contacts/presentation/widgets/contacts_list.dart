import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_state.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";
import "package:kinoapay_app/features/contacts/presentation/widgets/contact_action_sheet.dart";
import "package:kinoapay_app/features/contacts/presentation/widgets/contact_invite_sheet.dart";
import "package:kinoapay_app/features/contacts/presentation/widgets/contact_tile.dart";

/// Liste groupée par statut d'inscription (inscrit / autre).
class ContactsList extends StatelessWidget {
  final ContactsLoadSuccess state;
  const ContactsList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.filtered.isEmpty) return const _EmptySearchState();

    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        if (state.onApp.isNotEmpty) ...[
          _SectionHeader(label: "Sur ${AppStrings.appName}", count: state.onApp.length),
          _ContactGroup(contacts: state.onApp, actionable: true),
        ],
        if (state.others.isNotEmpty) ...[
          _SectionHeader(label: "Autres contacts", count: state.others.length),
          _ContactGroup(contacts: state.others, actionable: false),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  const _SectionHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.45),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.quinoaDark.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              "$count",
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.55),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactGroup extends StatelessWidget {
  final List<Contact> contacts;
  final bool actionable;
  const _ContactGroup({required this.contacts, required this.actionable});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: List.generate(contacts.length, (i) {
          final contact = contacts[i];
          return Column(
            children: [
              ContactTile(
                contact: contact,
                onTap: actionable
                    ? () => _showActionSheet(context, contact)
                    : () => _showInviteSheet(context, contact),
              ),
              if (i < contacts.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 78,
                  endIndent: 20,
                  color: AppColors.quinoaDark.withValues(alpha: 0.05),
                ),
            ],
          );
        }),
      ),
    );
  }

  void _showActionSheet(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ContactActionSheet(contact: contact),
    );
  }

  void _showInviteSheet(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ContactInviteSheet(contact: contact),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: AppColors.quinoaDark.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Text(
            "Aucun contact trouvé",
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.4),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
