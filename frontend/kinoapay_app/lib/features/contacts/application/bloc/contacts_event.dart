import "package:equatable/equatable.dart";

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();
  @override
  List<Object?> get props => [];
}

/// Déclenche le chargement initial des contacts (ignoré si déjà chargé).
class ContactsStarted extends ContactsEvent {
  const ContactsStarted();
}

/// Force un rechargement complet depuis la source, même si déjà chargé.
class ContactsRefreshed extends ContactsEvent {
  const ContactsRefreshed();
}

/// Met à jour le filtre de recherche en temps réel.
class ContactsSearchChanged extends ContactsEvent {
  final String query;
  const ContactsSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

/// Demande l'affichage de la page suivante (pagination en mémoire).
class ContactsMoreRequested extends ContactsEvent {
  const ContactsMoreRequested();
}
