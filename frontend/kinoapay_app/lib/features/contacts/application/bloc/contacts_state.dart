import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart";

abstract class ContactsState extends Equatable {
  const ContactsState();
  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {
  const ContactsInitial();
}

class ContactsLoading extends ContactsState {
  const ContactsLoading();
}

class ContactsLoadSuccess extends ContactsState {
  /// Tous les contacts chargés (non filtrés).
  final List<Contact> all;

  /// Résultat filtré selon la recherche active.
  final List<Contact> filtered;

  final String query;

  const ContactsLoadSuccess({
    required this.all,
    required this.filtered,
    this.query = "",
  });

  List<Contact> get onApp => filtered.where((c) => c.isRegistered).toList();
  List<Contact> get others => filtered.where((c) => !c.isRegistered).toList();

  @override
  List<Object?> get props => [all, filtered, query];
}

class ContactsError extends ContactsState {
  final String message;
  const ContactsError(this.message);
  @override
  List<Object?> get props => [message];
}
