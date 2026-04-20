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
  static const int pageSize = 25;

  /// Tous les contacts chargés, non filtrés.
  final List<Contact> all;

  /// Résultat filtré selon la recherche active.
  final List<Contact> filtered;

  final String query;

  /// Nombre de contacts actuellement affichés (pagination en mémoire).
  final int displayCount;

  const ContactsLoadSuccess({
    required this.all,
    required this.filtered,
    this.query = "",
    this.displayCount = pageSize,
  });

  /// Slice affiché à l'écran.
  List<Contact> get displayed => filtered.take(displayCount).toList();

  /// Indique si des contacts supplémentaires sont disponibles.
  bool get hasMore => filtered.length > displayCount;

  List<Contact> get onApp =>
      displayed.where((c) => c.isRegistered).toList();
  List<Contact> get others =>
      displayed.where((c) => !c.isRegistered).toList();

  ContactsLoadSuccess copyWith({
    List<Contact>? all,
    List<Contact>? filtered,
    String? query,
    int? displayCount,
  }) =>
      ContactsLoadSuccess(
        all: all ?? this.all,
        filtered: filtered ?? this.filtered,
        query: query ?? this.query,
        displayCount: displayCount ?? this.displayCount,
      );

  @override
  List<Object?> get props => [all, filtered, query, displayCount];
}

class ContactsError extends ContactsState {
  final String message;
  const ContactsError(this.message);
  @override
  List<Object?> get props => [message];
}
