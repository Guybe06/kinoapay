import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_bloc.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_event.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_state.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";
import "package:kinoapay_app/features/contacts/presentation/widgets/contact_tile.dart";

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ContactsBloc>().add(const ContactsStarted());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: KinoaColors.quinoaCream,
      body: Column(
        children: [
          _buildHeader(topInset),
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<ContactsBloc, ContactsState>(
              builder: (context, state) {
                if (state is ContactsLoading) return const _LoadingState();
                if (state is ContactsError) return _ErrorState(message: state.message);
                if (state is ContactsLoadSuccess) return _ContactsList(state: state);
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double topInset) {
    return Container(
      color: KinoaColors.quinoaCream,
      padding: EdgeInsets.fromLTRB(20, topInset + 16, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: KinoaColors.quinoaDark.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: KinoaColors.quinoaDark),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            "Contacts",
            style: TextStyle(
              color: KinoaColors.quinoaDark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (q) =>
            context.read<ContactsBloc>().add(ContactsSearchChanged(q)),
        style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 14),
        cursorColor: KinoaColors.quinoaGold,
        decoration: InputDecoration(
          hintText: "Rechercher un contact...",
          hintStyle: TextStyle(
            color: KinoaColors.quinoaDark.withValues(alpha: 0.3),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: KinoaColors.quinoaDark.withValues(alpha: 0.35),
            size: 20,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (_, val, _) => val.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      context.read<ContactsBloc>().add(const ContactsSearchChanged(""));
                    },
                    child: Icon(Icons.close_rounded,
                        size: 18, color: KinoaColors.quinoaDark.withValues(alpha: 0.4)),
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: KinoaColors.quinoaDark.withValues(alpha: 0.10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: KinoaColors.quinoaGold.withValues(alpha: 0.6), width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ── Liste des contacts ────────────────────────────────────────────────────────

class _ContactsList extends StatelessWidget {
  final ContactsLoadSuccess state;
  const _ContactsList({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.filtered.isEmpty) return const _EmptyState();

    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        if (state.onApp.isNotEmpty) ...[
          _SectionHeader(
            label: "Sur KinoaPay",
            count: state.onApp.length,
          ),
          _ContactGroup(contacts: state.onApp),
        ],
        if (state.others.isNotEmpty) ...[
          _SectionHeader(
            label: "Autres contacts",
            count: state.others.length,
          ),
          _ContactGroup(contacts: state.others),
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
              color: KinoaColors.quinoaDark.withValues(alpha: 0.45),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: KinoaColors.quinoaDark.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              "$count",
              style: TextStyle(
                color: KinoaColors.quinoaDark.withValues(alpha: 0.55),
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
  const _ContactGroup({required this.contacts});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: List.generate(contacts.length, (i) {
          return Column(
            children: [
              ContactTile(contact: contacts[i], onTap: () {}),
              if (i < contacts.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 78,
                  endIndent: 20,
                  color: KinoaColors.quinoaDark.withValues(alpha: 0.05),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ── États auxiliaires ─────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: KinoaColors.quinoaGold,
        strokeWidth: 2,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded,
              size: 48, color: KinoaColors.quinoaDark.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Text(
            "Aucun contact trouvé",
            style: TextStyle(
              color: KinoaColors.quinoaDark.withValues(alpha: 0.4),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: KinoaColors.quinoaRed, fontSize: 14),
      ),
    );
  }
}
