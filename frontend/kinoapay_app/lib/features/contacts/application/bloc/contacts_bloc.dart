import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_event.dart";
import "package:kinoapay_app/features/contacts/application/bloc/contacts_state.dart";
import "package:kinoapay_app/features/contacts/domain/repositories/contacts_repository.dart";

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactsRepository _repository;

  ContactsBloc({required ContactsRepository repository})
      : _repository = repository,
        super(const ContactsInitial()) {
    on<ContactsStarted>(_onStarted);
    on<ContactsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onStarted(
    ContactsStarted event,
    Emitter<ContactsState> emit,
  ) async {
    emit(const ContactsLoading());
    try {
      final contacts = await _repository.getContacts();
      emit(ContactsLoadSuccess(all: contacts, filtered: contacts));
    } catch (e) {
      // ignore: avoid_print
      print("Erreur ContactsBloc: $e");
      emit(const ContactsError("Impossible de charger les contacts."));
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

    emit(ContactsLoadSuccess(
      all: current.all,
      filtered: filtered,
      query: event.query,
    ));
  }
}
