import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_bloc.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_event.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_state.dart";
import "package:kinoapay_app/features/contacts/presentation/widgets/contacts_list.dart";
import "package:kinoapay_app/features/contacts/domain/contacts_strings.dart";

/// Liste des contacts : recherche et regroupement inscrits / autres.
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
      backgroundColor: AppColors.quinoaCream,
      body: Column(
        children: [
          _buildHeader(topInset),
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<ContactsBloc, ContactsState>(
              builder: (context, state) {
                if (state is ContactsLoading) return const _LoadingState();
                if (state is ContactsError)
                  return _ErrorState(message: state.message);
                if (state is ContactsLoadSuccess)
                  return ContactsList(state: state);
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
      color: AppColors.quinoaCream,
      padding: EdgeInsets.fromLTRB(20, topInset + 16, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.quinoaDark.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.quinoaDark,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              ContactsStrings.viewTitle,
              style: TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                context.read<ContactsBloc>().add(const ContactsStarted()),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.quinoaDark.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: AppColors.quinoaDark,
              ),
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
        style: const TextStyle(color: AppColors.quinoaDark, fontSize: 14),
        cursorColor: AppColors.quinoaGold,
        decoration: InputDecoration(
          hintText: ContactsStrings.searchHint,
          hintStyle: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.3),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.quinoaDark.withValues(alpha: 0.35),
            size: 20,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (_, val, _) => val.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      context.read<ContactsBloc>().add(
                        const ContactsSearchChanged(""),
                      );
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.quinoaDark.withValues(alpha: 0.4),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.quinoaDark.withValues(alpha: 0.10),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.quinoaGold.withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

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

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

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
