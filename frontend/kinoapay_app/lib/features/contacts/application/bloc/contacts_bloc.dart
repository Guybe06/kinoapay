import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_event.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_state.dart";
import "package:kinoapay_app/features/contacts/domain/repositories/contacts_repository.dart";
import "package:kinoapay_app/features/contacts/domain/contacts_strings.dart";

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactsRepository _repository;

  ContactsBloc({required ContactsRepository repository})
    : _repository = repository,
      super(const ContactsInitial()) {
    on<ContactsStarted>(_onStarted);
    on<ContactsRefreshed>(_onRefreshed);
    on<ContactsSearchChanged>(_onSearchChanged);
    on<ContactsMoreRequested>(_onMoreRequested);
  }

  Future<void> _onStarted(
    ContactsStarted event,
    Emitter<ContactsState> emit,
  ) async {
    if (state is ContactsLoadSuccess) return;
    emit(const ContactsLoading());
    try {
      final contacts = await _repository.getContacts();
      emit(ContactsLoadSuccess(all: contacts, filtered: contacts));
    } catch (_) {
      emit(const ContactsError(ContactsStrings.errorLoad));
    }
  }

  /// Recharge les contacts depuis zéro, affiche le skeleton pendant le fetch.
  Future<void> _onRefreshed(
    ContactsRefreshed event,
    Emitter<ContactsState> emit,
  ) async {
    emit(const ContactsLoading());
    try {
      final contacts = await _repository.getContacts();
      emit(ContactsLoadSuccess(all: contacts, filtered: contacts));
    } catch (_) {
      emit(const ContactsError(ContactsStrings.errorLoad));
    }
  }

  void _onSearchChanged(
    ContactsSearchChanged event,
    Emitter<ContactsState> emit,
  ) {
    final current = state;
    if (current is! ContactsLoadSuccess) return;

    final filtered = event.query.isEmpty
        ? current.all
        : _repository.search(current.all, event.query);

    emit(
      current.copyWith(
        filtered: filtered,
        query: event.query,
        displayCount: ContactsLoadSuccess.pageSize,
      ),
    );
  }

  /// Augmente le nombre de contacts affichés d'une page supplémentaire.
  void _onMoreRequested(
    ContactsMoreRequested event,
    Emitter<ContactsState> emit,
  ) {
    final current = state;
    if (current is! ContactsLoadSuccess) return;
    if (!current.hasMore) return;
    emit(current.copyWith(
      displayCount: current.displayCount + ContactsLoadSuccess.pageSize,
    ));
  }
}
