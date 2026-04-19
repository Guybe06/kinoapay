import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";

class _Contact {
  final String name;
  final String initials;
  const _Contact({required this.name, required this.initials});
}

/// Bande de contacts récents — dark mode, bouton d'ajout en premier, dans une card.
class DashboardRecentContacts extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback onAdd;

  const DashboardRecentContacts({
    super.key,
    required this.transactions,
    required this.onAdd,
  });

  List<_Contact> _extractContacts() {
    final seen = <String>{};
    final contacts = <_Contact>[];

    for (final tx in transactions) {
      final name = tx.direction == "sent"
          ? (tx.receiverName ?? "")
          : (tx.senderName ?? "");
      if (name.isEmpty || seen.contains(name)) continue;
      seen.add(name);
      final parts = name.trim().split(" ");
      final initials = parts
          .take(2)
          .map(
            (p) => p.isNotEmpty
                ? String.fromCharCode(p.runes.first).toUpperCase()
                : "",
          )
          .join();
      contacts.add(_Contact(name: name, initials: initials));
      if (contacts.length >= 8) break;
    }
    return contacts;
  }

  @override
  Widget build(BuildContext context) {
    final contacts = _extractContacts();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.quinoaDark.withValues(alpha: 0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.quinoaDark.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DashboardStrings.recentContacts,
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.85),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    DashboardStrings.seeMore,
                    style: TextStyle(
                      color: AppColors.quinoaGold.withValues(alpha: 0.80),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 88,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _AddContactBtn(onTap: onAdd),
                  const SizedBox(width: 12),
                  ...contacts.asMap().entries.map(
                    (entry) => Padding(
                      padding: EdgeInsets.only(
                        right: entry.key < contacts.length - 1 ? 12 : 0,
                      ),
                      child: _ContactItem(contact: entry.value),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddContactBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AddContactBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.quinoaDark.withValues(alpha: 0.05),
              border: Border.all(
                color: AppColors.quinoaDark.withValues(alpha: 0.12),
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              SolarIconsOutline.addCircle,
              size: 24,
              color: AppColors.quinoaDark.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            DashboardStrings.addContact,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.40),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final _Contact contact;
  const _ContactItem({required this.contact});

  @override
  Widget build(BuildContext context) {
    final firstName = contact.name.split(" ").first;
    final label = firstName.length > 8
        ? "${firstName.substring(0, 7)}."
        : firstName;

    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.stone100,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.stone200, width: 1),
            ),
            alignment: Alignment.center,
            child: const Icon(
              SolarIconsOutline.user,
              size: 22,
              color: AppColors.stone400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.55),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
