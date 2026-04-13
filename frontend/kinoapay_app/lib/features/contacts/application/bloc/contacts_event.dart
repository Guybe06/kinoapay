import "package:equatable/equatable.dart";

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();
  @override
  List<Object?> get props => [];
}

/// Déclenche le chargement initial des contacts.
class ContactsStarted extends ContactsEvent {
  const ContactsStarted();
}

/// Met à jour le filtre de recherche en temps réel.
class ContactsSearchChanged extends ContactsEvent {
  final String query;
  const ContactsSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}
